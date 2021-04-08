defmodule Get5Api.MatchConfigGeneratorTest do
  use Get5Api.DataCase

  alias Get5Api.Matches.MatchConfigGenerator

  @team1 %{
    name: "Team1",
    players: %{player1: "1", player2: "2", player3: "3", player4: "4", player5: "5"}
  }
  @team2 %{
    name: "Team2",
    players: %{player6: "", player7: "", player8: "", player9: "", player10: ""}
  }

  @valid_attrs %{
    id: "id-123-1223-uuid",
    series_type: :bo1,
    side_type: :standard,
    veto_map_pool: ["de_mirage", "de_inferno", "de_dust"],
    team1: @team1,
    team2: @team2
  }

  test "create a minimum config" do
    match =
      @valid_attrs
      |> Map.put(:team1, @team1)
      |> Map.put(:team2, @team2)

    config = MatchConfigGenerator.generate_config(match)

    assert config.id == "id-123-1223-uuid"
    assert config.team1.name == "Team1"
    assert config.team2.name == "Team2"
    assert config.series_type == :bo1
    assert config.team1.players.player1 == "1"
    assert config.team2.players.player6 == ""
  end
end
