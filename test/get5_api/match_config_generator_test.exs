defmodule Get5Api.MatchConfigGeneratorTest do
  use Get5Api.DataCase

  alias Get5Api.Matches.MatchConfigGenerator
  alias Get5Api.Teams.Player

  @team1 %{
    name: "Team1",
    players: [
      %Player{steam_id: "1", name: "player1"},
      %Player{steam_id: "2", name: "player2"},
      %Player{steam_id: "3", name: "player3"},
      %Player{steam_id: "4", name: "player4"},
      %Player{steam_id: "5", name: "player5"}
    ]
  }
  @team2 %{
    name: "Team2",
    players: [
      %Player{steam_id: "6", name: "player6"},
      %Player{steam_id: "7", name: "player7"},
      %Player{steam_id: "8", name: "player8"},
      %Player{steam_id: "9", name: "player9"},
      %Player{steam_id: "10", name: "player10"}
    ]
  }

  @valid_attrs %{
    id: 42,
    series_type: :bo1,
    side_type: :standard,
    maplist: ["de_mirage", "de_inferno", "de_dust"],
    team1: @team1,
    team2: @team2
  }

  test "create a minimum config" do
    match =
      @valid_attrs
      |> Map.put(:team1, @team1)
      |> Map.put(:team2, @team2)

    config = MatchConfigGenerator.generate_config(match)

    assert config.matchid == "42"
    assert config.team1.name == "Team1"
    assert config.team2.name == "Team2"
    assert config.num_maps == 1
    assert config.team1.players == %{
          "1" => "player1",
          "2" => "player2",
          "3" => "player3",
          "4" => "player4",
          "5" => "player5"
        }
     assert config.team2.players == %{
          "6" => "player6",
          "7" => "player7",
          "8" => "player8",
          "9" => "player9",
          "10" => "player10"
        }
  end
end
