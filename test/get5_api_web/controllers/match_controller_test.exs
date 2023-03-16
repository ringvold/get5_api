defmodule Get5ApiWeb.MatchControllerTest do
  use Get5ApiWeb.ConnCase

  import Get5Api.MatchesFixtures

  alias Get5Api.Matches.Match

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  @team1 %{
    id: 1,
    name: "Team1",
    players: %{
      "player1" => "1",
      "player2" => "2",
      "player3" => "3",
      "player4" => "4",
      "player5" => "5"
    }
  }
  @team2 %{
    id: 2,
    name: "Team2",
    players: %{
      "player6" => "6",
      "player7" => "7",
      "player8" => "8",
      "player9" => "9",
      "player10" => "10"
    }
  }

  @_valid_attrs %{
    api_key: "some api_key",
    end_time: "2010-04-17T14:00:00Z",
    enforce_teams: true,
    min_player_ready: 5,
    series_type: :bo1,
    side_type: :standard,
    spectator_ids: [],
    start_time: "2010-04-17T14:00:00Z",
    status: "some status",
    title: "some title",
    veto_first: "some veto_first",
    map_list: ["de_dust"],
    team1_score: 0,
    team2_score: 0
  }

  setup %{conn: conn} do
    {:ok,
     conn:
       put_req_header(conn, "accept", "application/json")
       |> put_req_header("content-type", "application/json")}
  end

  describe "get match config" do
    setup [:create_match]

    test "renders match config when api_key is valid", %{
      conn: conn,
      match: %Match{id: id} = match
    } do
      conn = put_req_header(conn, "authorization", "Bearer some api_key")
      conn = get(conn, ~p"/matches/#{match.id}/match-config")
      assert %{"map_list" => ["de_dust"]} = json_response(conn, 200)
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

    test "start series with valid payload", %{conn: conn, match: %Match{id: id} = match} do
      conn = put_req_header(conn, "authorization", "Bearer some api_key")
      conn = post(conn, ~p"/matches/#{match.id}/series-start", ~s|
        {
          "event": "series_start",
          "matchid": "14272",
          "team1_name": "NaVi",
          "team2_name": "Astralis"
        }
      |)

      assert conn.status == 200
    end

    test "start series with invalid payload", %{conn: conn, match: match} do
      conn = put_req_header(conn, "authorization", "Bearer some api_key")
      conn = post(conn, ~p"/matches/#{match.id}/series-start", ~s|
         {
           "invalid_field": "ekkomul"
         }
       |)

      assert conn.status == 400
      assert json_response(conn, 400) == %{"errors" => %{"detail" => "Invalid payload"}}
    end
  end

  defp create_match(_) do
    {:ok, match} = match_fixture()
    %{match: match}
  end
end
