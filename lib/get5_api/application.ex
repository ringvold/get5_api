defmodule Get5Api.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Get5Api.Repo,
      # Start the Telemetry supervisor
      Get5ApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Get5Api.PubSub},
      # Start the Endpoint (http/https)
      Get5ApiWeb.Endpoint
      # Start a worker by calling: Get5Api.Worker.start_link(arg)
      # {Get5Api.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Get5Api.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Get5ApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
