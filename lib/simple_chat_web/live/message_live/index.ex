defmodule SimpleChatWeb.MessageLive.Index do
  use SimpleChatWeb, :live_view

  alias SimpleChat.Chat
  alias SimpleChat.Accounts

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      SimpleChatWeb.Endpoint.subscribe("chat")
    end

    messages = Chat.list_messages()

    content_list =
      Enum.map(messages, &%{content: &1.content, sent_by: username(%{user_id: &1.user_id})})

    {:ok, assign(socket, username: username(%{socket: socket}), messages: content_list)}
  end

  @impl true
  def handle_info(%{event: "message", payload: payload}, socket) do
    message = %{content: payload.content, sent_by: payload.sent_by}
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message])}
  end

  @impl true
  def handle_event("send", %{"text" => text}, socket) do
    {:ok, message} =
      Chat.create_message(%{content: text, user_id: socket.assigns.current_user.id})

    SimpleChatWeb.Endpoint.broadcast("chat", "message", %{
      sent_by: username(%{user_id: message.user_id}),
      content: message.content
    })

    {:noreply, socket}
  end

  defp username(%{socket: socket}) do
    Accounts.get_user!(socket.assigns.current_user.id).name
  end

  defp username(%{user_id: user_id}) do
    Accounts.get_user!(user_id).name
  end
end
