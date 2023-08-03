defmodule Get5Api.StatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Get5Api.Stats` context.
  """

  @doc """
  Generate a map_stats.
  """
  def map_stats_fixture(attrs \\ %{}) do
    {:ok, map_stats} =
      attrs
      |> Enum.into(%{
        end_time: ~U[2023-07-18 20:50:00Z],
        map_name: "some map_name",
        map_number: 42,
        start_time: ~U[2023-07-18 20:50:00Z],
        team1_score: 42,
        team2_score: "some team2_score"
      })
      |> Get5Api.Stats.create_map_stats()

    map_stats
  end

  @doc """
  Generate a player_stats.
  """
  def player_stats_fixture(attrs \\ %{}) do
    {:ok, player_stats} =
      attrs
      |> Enum.into(%{
        "1v2": 42,
        damage: 42,
        "1v1": 42,
        team_kills: 42,
        enemies_flashed: 42,
        kill: 42,
        utility_damage: 42,
        "1v5": 42,
        kast: 42,
        "5k": 42,
        "1k": 42,
        "1v4": 42,
        mvp: 42,
        knife_kills: 42,
        "1v3": 42,
        first_kills_ct: 42,
        first_deaths_t: 42,
        first_kills_t: 42,
        deaths: 42,
        trade_kills: 42,
        friendlies_flashed: 42,
        bomb_plants: 42,
        bomb_defuses: 42,
        assists: 42,
        "4k": 42,
        score: 42,
        "3k": 42,
        suicides: 42,
        headshot_kills: 42,
        first_deaths_ct: 42,
        rounds_played: 42,
        flash_assists: 42,
        "2k": 42
      })
      |> Get5Api.Stats.create_player_stats()

    player_stats
  end
end
