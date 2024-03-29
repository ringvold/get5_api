defmodule Get5ApiWeb.MatchControllerTest do
  use Get5ApiWeb.ConnCase

  import Get5Api.MatchesFixtures
  import Get5Api.MapSelectionsFixtures

  alias Get5Api.Get5Api.MapSelections
  alias Get5Api.Matches.Match
  alias Get5Api.Stats

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok,
     conn:
       put_req_header(conn, "accept", "application/json")
       |> put_req_header("content-type", "application/json")}
  end

  describe "Match config" do
    setup [:create_match]

    test "renders match config when api_key is valid", %{
      conn: conn,
      match: %Match{id: id} = match
    } do
      conn = put_req_header(conn, "authorization", "Bearer some_api_key")
      conn = get(conn, ~p"/matches/#{match.id}/match-config")

      assert %{
               "matchid" => id,
               "num_maps" => 1,
               "team1" => %{"name" => "Team 1", "players" => %{}},
               "team2" => %{"name" => "Team 2", "players" => %{}},
               "maplist" => ["de_dust"]
             } = json_response(conn, 200)
    end

    test "renders errors when api_key is invalid", %{conn: conn, match: match} do
      conn = put_req_header(conn, "authorization", "Bearer invalid api_key")
      conn = get(conn, ~p"/matches/#{match.id}/match-config")
      assert json_response(conn, 401)["errors"] != %{errors: %{detail: "Forbidden"}}
    end

    test "renders errors when auth header missing", %{conn: conn, match: match} do
      conn = get(conn, ~p"/matches/#{match.id}/match-config")
      assert json_response(conn, 400)["errors"] != %{errors: %{detail: "Bad request"}}
    end
  end

  describe "Get5 callback" do
    setup [:create_match]

    test "OnSeriesInit", %{conn: conn, match: match} do
      conn = put_req_header(conn, "authorization", "Bearer some_api_key")
      conn = post(conn, ~p"/matches/#{match.id}/events", ~s|
        {
          "event": "series_start",
          "matchid": "#{match.id}",
          "team1_name": "NaVi",
          "team2_name": "Astralis"
        }
      |)
      match = Get5Api.Matches.get_match!(match.id)
      assert conn.status == 200
      assert match.start_time != nil
    end

    test "OnMapResult", %{conn: conn, match: match} do
      conn = put_req_header(conn, "authorization", "Bearer some_api_key")
      conn = post(conn, ~p"/matches/#{match.id}/events", ~s|
        {
          "event": "map_result",
          "matchid": #{match.id},
          "map_number": 0,
          "team1": {
            "id": #{match.team1.id},
            "name": "Natus Vincere",
            "series_score": 0,
            "score": 14,
            "score_ct": 10,
            "score_t": 14,
            "players": [
              {
                "steamid": "76561198279375306",
                "name": "s1mple",
                "stats": {
                  "kills": 34,
                  "deaths": 8,
                  "assists": 5,
                  "flash_assists": 3,
                  "team_kills": 0,
                  "suicides": 0,
                  "damage": 2948,
                  "utility_damage": 173,
                  "enemies_flashed": 6,
                  "friendlies_flashed": 2,
                  "knife_kills": 1,
                  "headshot_kills": 19,
                  "rounds_played": 27,
                  "bomb_defuses": 4,
                  "bomb_plants": 3,
                  "1k": 3,
                  "2k": 2,
                  "3k": 3,
                  "4k": 0,
                  "5k": 1,
                  "1v1": 1,
                  "1v2": 3,
                  "1v3": 2,
                  "1v4": 0,
                  "1v5": 1,
                  "first_kills_t": 6,
                  "first_kills_ct": 5,
                  "first_deaths_t": 1,
                  "first_deaths_ct": 1,
                  "trade_kills": 3,
                  "kast": 23,
                  "score": 45,
                  "mvp": 4
                }
              }
            ],
            "side": "ct",
            "starting_side": "ct"
          },
          "team2": {
            "id": #{match.team2.id},
            "name": "Astralis",
            "series_score": 0,
            "score": 14,
            "score_ct": 10,
            "score_t": 14,
            "players": [
              {
                "steamid": "76561197990682262",
                "name": "xyp9x",
                "stats": {
                  "kills": 20,
                  "deaths": 15,
                  "assists": 2,
                  "flash_assists": 3,
                  "team_kills": 0,
                  "suicides": 0,
                  "damage": 1000,
                  "utility_damage": 93,
                  "enemies_flashed": 6,
                  "friendlies_flashed": 4,
                  "knife_kills": 0,
                  "headshot_kills": 3,
                  "rounds_played": 27,
                  "bomb_defuses": 4,
                  "bomb_plants": 3,
                  "1k": 3,
                  "2k": 2,
                  "3k": 3,
                  "4k": 0,
                  "5k": 1,
                  "1v1": 1,
                  "1v2": 3,
                  "1v3": 2,
                  "1v4": 0,
                  "1v5": 1,
                  "first_kills_t": 6,
                  "first_kills_ct": 5,
                  "first_deaths_t": 1,
                  "first_deaths_ct": 1,
                  "trade_kills": 3,
                  "kast": 23,
                  "score": 45,
                  "mvp": 4
                }
              }
            ],
            "side": "ct",
            "starting_side": "ct"
          },
          "winner": {
            "side": "ct",
            "team": "team1"
          }
        }
      |)

      [player_stats | rest] = Stats.list_player_stats()
      assert conn.status == 200
      assert player_stats.steam_id == "76561198279375306"
      assert player_stats.name == "s1mple"
      assert player_stats.kills == 34
      assert player_stats.deaths == 8
      assert player_stats.assists == 5
      assert player_stats.flash_assists == 3
      assert player_stats.team_kills == 0
      assert player_stats.suicides == 0
      assert player_stats.damage == 2948
      assert player_stats.utility_damage == 173
      assert player_stats.enemies_flashed == 6
      assert player_stats.friendlies_flashed == 2
      assert player_stats.knife_kills == 1
      assert player_stats.headshot_kills == 19
      assert player_stats.rounds_played == 27
      assert player_stats.bomb_defuses == 4
      assert player_stats.bomb_plants == 3
      assert player_stats."1k" == 3
      assert player_stats."2k" == 2
      assert player_stats."3k" == 3
      assert player_stats."4k" == 0
      assert player_stats."5k" == 1
      assert player_stats."1v1" == 1
      assert player_stats."1v2" == 3
      assert player_stats."1v3" == 2
      assert player_stats."1v4" == 0
      assert player_stats."1v5" == 1
      assert player_stats.first_kills_t == 6
      assert player_stats.first_kills_ct == 5
      assert player_stats.first_deaths_t == 1
      assert player_stats.first_deaths_ct == 1
      assert player_stats.trade_kills == 3
      assert player_stats.kast == 23
      assert player_stats.score == 45
      assert player_stats.mvp == 4
    end

    test "OnSeriesResult", %{conn: conn, match: match} do
      conn = put_req_header(conn, "authorization", "Bearer some_api_key")
      conn = post(conn, ~p"/matches/#{match.id}/events", ~s|
        {
          "event": "series_end",
          "matchid": #{match.id},
          "team1_series_score": 2,
          "team2_series_score": 0,
          "winner": {
            "side": "ct",
            "team": "team1"
          },
          "time_until_restore": 45
        }
      |)
      match = Get5Api.Matches.get_match!(match.id)
      assert conn.status == 200
      assert match.team1_score == 2
      assert match.team2_score == 0
    end

    test "OnSidePicked", %{conn: conn, match: match} do
      map_selection = map_selection_fixture(%{match_id: match.id})

      conn = put_req_header(conn, "authorization", "Bearer some_api_key")
      conn = post(conn, ~p"/matches/#{match.id}/events", ~s|
       {
        "event": "side_picked",
        "matchid": "#{match.id}",
        "team": "team1",
        "map_name": "de_nuke",
        "side": "ct",
        "map_number": 0

       }
      |)
      side_selections = Get5Api.MapSelections.list_side_selections()
      side = Enum.at(side_selections, 0)
      assert conn.status == 200
      assert length(side_selections) == 1
      assert side.match_id == match.id
      assert side.map_selection_id == map_selection.id
      assert side.team_name == match.team1.name
    end
  end

  defp create_match(_) do
    {:ok, match} = match_fixture()
    %{match: match}
  end
end
