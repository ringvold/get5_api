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
        api_key: "some api_key",
        series_type: :bo1_preset,
        side_type: :standard,
        veto_map_pool: ["de_dust"],
        team1_id: team_fixture().id,
        team2_id: team_fixture().id,
        game_server_id: game_server_fixture().id
      })
      |> Get5Api.Matches.create_match()
  end
end
