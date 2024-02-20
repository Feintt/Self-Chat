defmodule SimpleChat.Repo do
  use Ecto.Repo,
    otp_app: :simple_chat,
    adapter: Ecto.Adapters.Postgres
end
