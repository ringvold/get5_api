defmodule Get5Api.StatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Get5Api.Stats` context.
  """

  @doc """
  Generate a match_stats.
  """
  def match_stats_fixture(attrs \\ %{}) do
    {:ok, match_stats} =
      attrs
      |> Enum.into(%{
        end_time: ~U[2023-03-16 19:45:00Z],
        map_name: "some map_name",
        map_number: 42,
        start_time: ~U[2023-03-16 19:45:00Z],
        team1_score: 42,
        team2_score: "some team2_score"
      })
      |> Get5Api.Stats.create_match_stats()

    match_stats
  end
end
