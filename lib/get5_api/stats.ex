defmodule Get5Api.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false
  alias Get5Api.Repo

  alias Get5Api.Matches.Match
  alias Get5Api.Stats.MapStats
  alias Get5Api.Stats.PlayerStats
  alias Ecto.Multi

  def store_map_result(%Match{} = match, payload) do
    Multi.new()
    |> Multi.run(:map_stats, fn repo, _changes ->
      MapStats.changeset(%MapStats{}, %{
        team1_score: payload["team1"]["score"],
        team2_score: payload["team2"]["score"],
        map_number: payload["map_number"],
        match_id: match.id,
        winner_id: get_winner_id(payload)
      })
      |> repo.insert
    end)
    |> Ecto.Multi.insert_all(:players_team1, PlayerStats, fn %{map_stats: map} ->
      payload_to_player_stats(payload["team1"]["players"], match.id, map.id, payload["team1"]["id"])
    end)
    |> Ecto.Multi.insert_all(:players_team2, PlayerStats, fn %{map_stats: map} ->
      payload_to_player_stats(payload["team2"]["players"], match.id, map.id, payload["team2"]["id"])
    end)
    |> Repo.transaction()
  end

  def get_winner_id(payload) do
    if payload["winner"]["team"] == "team1" do
      payload["team1"]["id"]
    else
      payload["team2"]["id"]
    end
  end

  defp payload_to_player_stats(payload, match_id, map_id, team_id) do
    payload
    |> Enum.with_index()
    |> Enum.map(fn {player_payload, _idx} ->
      %{
        match_id: match_id,
        map_stats_id: map_id,
        team_id: team_id,
        inserted_at: DateTime.utc_now() |> DateTime.to_naive() |> NaiveDateTime.truncate(:second),
        updated_at: DateTime.utc_now() |> DateTime.to_naive() |> NaiveDateTime.truncate(:second),
        steam_id: player_payload["steamid"],
        assists: player_payload["stats"]["assists"],
        bomb_defuses: player_payload["stats"]["bomb_defuses"],
        bomb_plants: player_payload["stats"]["bomb_plants"],
        damage: player_payload["stats"]["damage"],
        deaths: player_payload["stats"]["deaths"],
        enemies_flashed: player_payload["stats"]["enemies_flashed"],
        flash_assists: player_payload["stats"]["flash_assists"],
        friendlies_flashed: player_payload["stats"]["friendlies_flashed"],
        headshot_kills: player_payload["stats"]["headshot_kills"],
        mvp: player_payload["stats"]["mvp"],
        kast: player_payload["stats"]["kast"],
        kill: player_payload["stats"]["kill"],
        knife_kills: player_payload["stats"]["knife_kills"],
        rounds_played: player_payload["stats"]["rounds_played"],
        team_kills: player_payload["stats"]["team_kills"],
        trade_kills: player_payload["stats"]["trade_kills"],
        score: player_payload["stats"]["score"],
        suicides: player_payload["stats"]["suicides"],
        utility_damage: player_payload["stats"]["utility_damage"],
        "1k": player_payload["stats"]["1k"],
        "2k": player_payload["stats"]["2k"],
        "3k": player_payload["stats"]["3k"],
        "4k": player_payload["stats"]["4k"],
        "5k": player_payload["stats"]["5k"],
        "1v1": player_payload["stats"]["1v1"],
        "1v2": player_payload["stats"]["1v2"],
        "1v3": player_payload["stats"]["1v3"],
        "1v4": player_payload["stats"]["1v4"],
        "1v5": player_payload["stats"]["1v5"],
        first_kills_t: player_payload["stats"]["first_kills_t"],
        first_kills_ct: player_payload["stats"]["first_kills_ct"],
        first_deaths_t: player_payload["stats"]["first_deaths_t"],
        first_deaths_ct: player_payload["stats"]["first_deaths_ct"]
      }
    end)
  end

  @doc """
  Returns the list of map_stats.

  ## Examples

      iex> list_map_stats()
      [%MapStats{}, ...]

  """
  def list_map_stats do
    Repo.all(MapStats)
  end

  @doc """
  Gets a single map_stats.

  Raises `Ecto.NoResultsError` if the Map stats does not exist.

  ## Examples

      iex> get_map_stats!(123)
      %MapStats{}

      iex> get_map_stats!(456)
      ** (Ecto.NoResultsError)

  """
  def get_map_stats!(id), do: Repo.get!(MapStats, id)

  def get_by_match_and_map_number(match_id, map_number) do
    MapStats.by_match_and_map_number(match_id, map_number)
    |> Repo.all()
  end

  @doc """
  Creates a map_stats.

  ## Examples

      iex> create_map_stats(%{field: value})
      {:ok, %MapStats{}}

      iex> create_map_stats(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_map_stats(attrs \\ %{}) do
    %MapStats{}
    |> MapStats.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a map_stats.

  ## Examples

      iex> update_map_stats(map_stats, %{field: new_value})
      {:ok, %MapStats{}}

      iex> update_map_stats(map_stats, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_map_stats(%MapStats{} = map_stats, attrs) do
    map_stats
    |> MapStats.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a map_stats.

  ## Examples

      iex> delete_map_stats(map_stats)
      {:ok, %MapStats{}}

      iex> delete_map_stats(map_stats)
      {:error, %Ecto.Changeset{}}

  """
  def delete_map_stats(%MapStats{} = map_stats) do
    Repo.delete(map_stats)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking map_stats changes.

  ## Examples

      iex> change_map_stats(map_stats)
      %Ecto.Changeset{data: %MapStats{}}

  """
  def change_map_stats(%MapStats{} = map_stats, attrs \\ %{}) do
    MapStats.changeset(map_stats, attrs)
  end

  alias Get5Api.Stats.PlayerStats

  @doc """
  Returns the list of player_stats.

  ## Examples

      iex> list_player_stats()
      [%PlayerStats{}, ...]

  """
  def list_player_stats do
    Repo.all(PlayerStats)
  end

  @doc """
  Gets a single player_stats.

  Raises `Ecto.NoResultsError` if the Player stats does not exist.

  ## Examples

      iex> get_player_stats!(123)
      %PlayerStats{}

      iex> get_player_stats!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player_stats!(id), do: Repo.get!(PlayerStats, id)

  @doc """
  Creates a player_stats.

  ## Examples

      iex> create_player_stats(%{field: value})
      {:ok, %PlayerStats{}}

      iex> create_player_stats(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player_stats(attrs \\ %{}) do
    %PlayerStats{}
    |> PlayerStats.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player_stats.

  ## Examples

      iex> update_player_stats(player_stats, %{field: new_value})
      {:ok, %PlayerStats{}}

      iex> update_player_stats(player_stats, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player_stats(%PlayerStats{} = player_stats, attrs) do
    player_stats
    |> PlayerStats.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a player_stats.

  ## Examples

      iex> delete_player_stats(player_stats)
      {:ok, %PlayerStats{}}

      iex> delete_player_stats(player_stats)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player_stats(%PlayerStats{} = player_stats) do
    Repo.delete(player_stats)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player_stats changes.

  ## Examples

      iex> change_player_stats(player_stats)
      %Ecto.Changeset{data: %PlayerStats{}}

  """
  def change_player_stats(%PlayerStats{} = player_stats, attrs \\ %{}) do
    PlayerStats.changeset(player_stats, attrs)
  end
end
