defmodule Get5Api.GameServers do
  @moduledoc """
  The GameServers context.
  """

  import Ecto.Query, warn: false
  alias Get5Api.Repo

  alias Get5Api.GameServers.GameServer
  alias Get5Api.Encryption
  alias Get5Api.Accounts.User

  @doc """
  Returns the list of game_servers.

  ## Examples

      iex> list_game_servers()
      [%GameServer{}, ...]

  """
  def list_game_servers(user_id) do
    if user_id do
      Repo.all(
        from g in GameServer,
          where: g.public == true or g.user_id == ^user_id,
          order_by: [asc: :inserted_at]
      )
    else
      list_public_game_servers()
    end
  end

  def list_public_game_servers do
    Repo.all(
      from g in GameServer,
        order_by: [asc: :inserted_at]
    )
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
  end

  def update_game_server(%User{} = user, %GameServer{} = game_server, attrs) do
    if game_server.user_id == user.id do
      update_game_server(game_server, attrs)
    else
      {:error, :unauthorized}
    end
  end

  @doc """
  Deletes a game_server.

  ## Examples

      iex> delete_game_server(user, game_server)
      {:ok, %GameServer{}}

      iex> delete_game_server(user, game_server)
      {:error, %Ecto.Changeset{}}

      iex> delete_game_server(user, game_server)
      {:error, :unauthorized}

  """
  def delete_game_server(%User{} = user, %GameServer{} = game_server) do
    if game_server.user_id == user.id do
      Repo.delete(game_server)
    else
      {:error, :unauthorized}
    end
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
    if String.trim(encryptet_password) != "" do
      Encryption.decrypt(encryptet_password)
    else
      ""
    end
  end
end
