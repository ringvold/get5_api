defmodule Get5Api.MatchesFixtures do

  import Get5Api.TeamsFixtures
  import Get5Api.GameServersFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Get5Api.Matches` context.
  """

  @doc """
  Generate a match.
  """
  def match_fixture(attrs \\ %{}) do
      attrs
      |> Enum.into(%{
        api_key: "some_api_key",
        series_type: :bo1_preset,
        side_type: :standard,
        map_list: ["de_dust"],
        plugin_version: "unknown",
        team1_id: team1_fixture().id,
        team2_id: team2_fixture().id,
        game_server_id: game_server_fixture().id
      })
      |> Get5Api.Matches.create_match()
  end
end
