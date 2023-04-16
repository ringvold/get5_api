defmodule Get5Api.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  alias Get5Api.Repo

  alias Get5Api.Teams.Team
  alias Get5Api.Teams.Player

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(
      from t in Team,
        order_by: [asc: :inserted_at]
    )
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)

  def get_team(id), do: Repo.get(Team, id)

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Adds player to team

  ## Examples

      iex> add_player(team, %Player{name: "First Last", steam_id: "1234556789"})
      {:ok, %Team{}}

      iex> add_player(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def add_player(%Team{} = team, %Player{} = player, attrs \\ %{}) do
    player = change_player(player, attrs)
    players = [player | team.players]

    result =
      team
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_embed(:players, players)
      |> Repo.update()

    case result do
      {:ok, team} ->
        {:ok, team.players}

      rest ->
        rest
    end
  end

  def remove_player(%Team{} = team, %Player{} = player) do
    players = Enum.reject(team.players, &(&1.steam_id == player.steam_id))

    result =
      team
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_embed(:players, players)
      |> Repo.update()

    case result do
      {:ok, team} ->
        {:ok, team}

      rest ->
        rest
    end
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    team
    |> Team.changeset(%{})
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  def change_player(%Player{} = player, attrs \\ %{}) do
    Player.changeset(player, attrs)
  end
end
