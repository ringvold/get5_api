defmodule Get5ApiWeb.MatchControllerTest do
  use Get5ApiWeb.ConnCase

  import Get5Api.MatchesFixtures

  alias Get5Api.Matches.Match

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

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
