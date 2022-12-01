defmodule Get5Api.GameServers do
  @moduledoc """
  The GameServers context.
  """

  import Ecto.Query, warn: false
  alias Get5Api.Repo

  alias Get5Api.GameServers.GameServer
  alias Get5Api.Encryption

  @doc """
  Returns the list of game_servers.

  ## Examples

      iex> list_game_servers()
      [%GameServer{}, ...]

  """
  def list_game_servers do
    Repo.all(GameServer)
  end

  @doc """
  Gets a single game_server.

  Raises `Ecto.NoResultsError` if the Game server does not exist.

  ## Examples

      iex> get_game_server!(123)
      %GameServer{}

      iex> get_game_server!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game_server!(id), do: Repo.get!(GameServer, id)

  def get_game_server(id), do: Repo.get(GameServer, id)

  @doc """
  Creates a game_server.

  ## Examples

      iex> create_game_server(%{field: value})
      {:ok, %GameServer{}}

      iex> create_game_server(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game_server(attrs \\ %{}) do
    %GameServer{}
    |> GameServer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game_server.

  ## Examples

      iex> update_game_server(game_server, %{field: new_value})
      {:ok, %GameServer{}}

      iex> update_game_server(game_server, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game_server(%GameServer{} = game_server, attrs \\ %{}) do
    game_server
    |> GameServer.update_changeset(attrs)
    |> Repo.update()
    |> dbg
  end

  @doc """
  Deletes a game_server.

  ## Examples

      iex> delete_game_server(game_server)
      {:ok, %GameServer{}}

      iex> delete_game_server(game_server)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game_server(%GameServer{} = game_server) do
    Repo.delete(game_server)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game_server changes.

  ## Examples

      iex> change_game_server(game_server)
      %Ecto.Changeset{data: %GameServer{}}

  """
  def change_game_server(%GameServer{} = game_server, attrs \\ %{}) do
    GameServer.update_changeset(game_server, attrs)
  end

  def decrypt_rcon_password(encryptet_password) do
    if String.strip(encryptet_password) != "" do
      Encryption.decrypt(encryptet_password)
    else
      ""
    end
  end
end
