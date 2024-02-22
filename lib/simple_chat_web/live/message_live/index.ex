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
    content_list = Enum.map(messages, & &1.content)
    {:ok, assign(socket, username: username(socket), messages: content_list)}
  end

  @impl true
  def handle_info(%{event: "message", payload: message}, socket) do
    IO.inspect("Here----------------")
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message.text])}
  end

  @impl true
  def handle_event("send", %{"text" => text}, socket) do
    SimpleChatWeb.Endpoint.broadcast("chat", "message", %{
      text: text
    })

    {:noreply, socket}
  end

  defp username(socket) do
    Accounts.get_user!(socket.assigns.current_user.id).email
  end
end
