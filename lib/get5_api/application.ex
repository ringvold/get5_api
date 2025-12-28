defmodule Get5Api.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children =
      [
        Get5Api.Repo,
        Get5ApiWeb.Telemetry,
        {Phoenix.PubSub, name: Get5Api.PubSub},
        {Finch, name: Get5Api.Finch},
        Get5ApiWeb.Endpoint
      ] ++ env_children(System.get_env("MIX_ENV"))

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

  defp env_children("test") do
    [
      # TCP lib for Rcon mock
      {ThousandIsland, port: 27015, handler_module: Get5Api.RconServerMock}
    ]
  end

  defp env_children(_), do: []
end
