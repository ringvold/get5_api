defmodule Get5Api.Matches do
  @moduledoc """
  The Matches context.
  """
  require Logger

  import Ecto.Query, warn: false
  alias Get5Api.Repo

  alias Get5Api.Matches.Match
  alias Get5Api.GameServers.Get5Client

  @doc """
  Returns the list of matches.

  ## Examples

      iex> list_matches()
      [%Match{}, ...]

  """
  def list_matches(user_id) do
    if user_id do
      Repo.all(
        from m in Match,
          where: m.public == true or m.user_id == ^user_id,
          preload: [:team1, :team2, :game_server],
          order_by: [asc: :inserted_at]
      )
    else
      list_public_matches()
    end
  end


  def list_public_matches do
    Repo.all(
      from m in Match,
        where: m.public == true,
        preload: [:team1, :team2, :game_server],
        order_by: [asc: :inserted_at]
    )
  end

  @doc """
  Gets a single match.

  Raises `Ecto.NoResultsError` if the Match does not exist.

  ## Examples

      iex> get_match!(123)
      %Match{}

      iex> get_match!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match!(id), do: Repo.get!(Match, id) |> Repo.preload([:team1, :team2, :game_server])

  def get_match(id), do: Repo.get(Match, id) |> Repo.preload([:team1, :team2, :game_server])

  @doc """
  Creates a match.

  ## Examples

      iex> create_match(%{field: value})
      {:ok, %Match{}}

      iex> create_match(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match(attrs \\ %{}) do
    with {:ok, match} <-
           %Match{}
           |> Match.changeset(attrs)
           |> Repo.insert() do
      {:ok, Repo.preload(match, [:game_server, :team1, :team2])}
    else
      err ->
        err
    end
  end

  def create_and_start_match(attrs \\ %{}) do
    with {:ok, match} <-
           create_match(attrs) do
      case Get5Client.start_match(match) do
        {:ok, result} ->
          {:ok, match, result}

        {:error, :nxdomain} ->
          {:warn, match, :domain_does_not_exist}

        {:error, :other_match_already_loaded} ->
          {:warn, match, :other_match_already_loaded}
      end
    else
      err ->
        Logger.error("Failed to start match: #{inspect(err)}")
        err
    end
  end

  @doc """
  Updates a match.

  ## Examples

      iex> update_match(match, %{field: new_value})
      {:ok, %Match{}}

      iex> update_match(match, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match(%Match{} = match, attrs) do
    match
    |> Match.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a match.

  ## Examples

      iex> delete_match(match)
      {:ok, %Match{}}

      iex> delete_match(match)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match(%Match{} = match) do
    Repo.delete(match)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match changes.

  ## Examples

      iex> change_match(match)
      %Ecto.Changeset{data: %Match{}}

  """
  def change_match(%Match{} = match, attrs \\ %{}) do
    Match.changeset(match, attrs)
  end
end
