defmodule Get5Api.GameServersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Get5Api.GameServers` context.
  """

  @doc """
  Generate a game_server.
  """
  def game_server_fixture(attrs \\ %{}) do
    {:ok, game_server} =
      attrs
      |> Enum.into(%{
        host: "localhost",
        name: "some name",
        port: 27015,
        rcon_password: "le-password"
      })
      |> Get5Api.GameServers.create_game_server()

    game_server
  end
end
