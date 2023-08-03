defmodule Slink.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SlinkWeb.Telemetry,
      # Start the Ecto repository
      Slink.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Slink.PubSub},
      # Start Finch
      {Finch, name: Slink.Finch},
      # Start the Endpoint (http/https)
      SlinkWeb.Endpoint
      # Start a worker by calling: Slink.Worker.start_link(arg)
      # {Slink.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Slink.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SlinkWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
