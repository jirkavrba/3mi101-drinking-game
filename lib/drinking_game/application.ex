defmodule DrinkingGame.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      DrinkingGameWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DrinkingGame.PubSub},
      # Start the Endpoint (http/https)
      DrinkingGameWeb.Endpoint,
      DrinkingGame.Presence,
      DrinkingGame.GameServer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DrinkingGame.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DrinkingGameWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
