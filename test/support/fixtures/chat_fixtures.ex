defmodule SimpleChat.ChatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SimpleChat.Chat` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> SimpleChat.Chat.create_message()

    message
  end
end
