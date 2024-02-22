defmodule SimpleChatWeb.MessageLive.Index do
  use SimpleChatWeb, :live_view

  alias SimpleChat.Chat

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      SimpleChatWeb.Endpoint.subscribe("chat")
    end

    {:ok, assign(socket, username: username(socket), messages: [])}
  end

  @impl true
  def handle_info(%{event: "message", payload: message}, socket) do
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message])}
  end

  @impl true
  def handle_event("send", %{"text" => text}, socket) do
    SimpleChatWeb.Endpoint.broadcast("chat", "message", %{
      text: text,
      name: socket.assigns.username
    })

    {:noreply, socket}
  end

  defp username(socket) do
    socket.assigns.current_user.id
  end
end
