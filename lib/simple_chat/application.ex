defmodule SimpleChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SimpleChatWeb.Telemetry,
      SimpleChat.Repo,
      {DNSCluster, query: Application.get_env(:simple_chat, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SimpleChat.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SimpleChat.Finch},
      # Start a worker by calling: SimpleChat.Worker.start_link(arg)
      # {SimpleChat.Worker, arg},
      # Start to serve requests, typically the last entry
      SimpleChatWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SimpleChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SimpleChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
