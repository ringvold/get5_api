defmodule Get5Api.GameServersTest do
  use Get5Api.DataCase

  alias Get5Api.GameServers

  describe "game_servers" do
    alias Get5Api.GameServers.GameServer

    @valid_attrs %{
      host: "csgo.example.com",
      in_use: true,
      name: "some name",
      port: 27015,
      gotv_port: 27020,
      rcon_password: "some rcon_password"
    }
    @update_attrs %{
      host: "10.0.0.10",
      in_use: false,
      name: "some updated name",
      port: 27016,
      gotv_port: 27021,
      rcon_password: "some updated rcon_password"
    }
    @invalid_attrs %{host: nil, in_use: nil, name: nil, port: nil, rcon_password: nil}

    def game_server_fixture(attrs \\ %{}) do
      {:ok, game_server} =
        attrs
        |> Enum.into(@valid_attrs)
        |> GameServers.create_game_server()

      game_server
    end

    test "list_game_servers/0 returns all game_servers" do
      game_server = game_server_fixture()
      assert GameServers.list_game_servers() == [game_server]
    end

    test "get_game_server!/1 returns the game_server with given id" do
      game_server = game_server_fixture()
      assert GameServers.get_game_server!(game_server.id) == game_server
    end

    test "create_game_server/1 with valid data creates a game_server" do
      assert {:ok, %GameServer{} = game_server} = GameServers.create_game_server(@valid_attrs)
      assert game_server.host == "csgo.example.com"
      assert game_server.in_use == true
      assert game_server.name == "some name"
      assert game_server.port == 27015
      assert game_server.gotv_port == 27020
      assert game_server.rcon_password != ""
    end

    test "create_game_server/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GameServers.create_game_server(@invalid_attrs)
    end

    test "update_game_server/2 with valid data updates the game_server" do
      game_server = game_server_fixture()

      assert {:ok, %GameServer{} = game_server} =
               GameServers.update_game_server(game_server, @update_attrs)

      assert game_server.host == "10.0.0.10"
      assert game_server.in_use == false
      assert game_server.name == "some updated name"
      assert game_server.port == 27016
      assert game_server.rcon_password == "some updated rcon_password"
    end

    test "update_game_server/2 with invalid data returns error changeset" do
      game_server = game_server_fixture()

      assert {:error, %Ecto.Changeset{}} =
               GameServers.update_game_server(game_server, @invalid_attrs)

      assert game_server == GameServers.get_game_server!(game_server.id)
    end

    test "delete_game_server/1 deletes the game_server" do
      game_server = game_server_fixture()
      assert {:ok, %GameServer{}} = GameServers.delete_game_server(game_server)
      assert_raise Ecto.NoResultsError, fn -> GameServers.get_game_server!(game_server.id) end
    end

    test "change_game_server/1 returns a game_server changeset" do
      game_server = game_server_fixture()
      assert %Ecto.Changeset{} = GameServers.change_game_server(game_server)
    end
  end
end
