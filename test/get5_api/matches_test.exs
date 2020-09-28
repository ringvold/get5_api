defmodule Get5Api.MatchesTest do
  use Get5Api.DataCase

  alias Get5Api.Matches

  describe "matches" do
    alias Get5Api.Matches.Match

    @valid_attrs %{api_key: "some api_key", end_time: "2010-04-17T14:00:00Z", enforce_teams: true, max_maps: 42, min_player_ready: 42, series_type: "some series_type", side_type: "some side_type", spectator_ids: [], start_time: "2010-04-17T14:00:00Z", status: "some status", team1_score: 42, team2_score: 42, title: "some title", veto_first: "some veto_first", veto_map_pool: []}
    @update_attrs %{api_key: "some updated api_key", end_time: "2011-05-18T15:01:01Z", enforce_teams: false, max_maps: 43, min_player_ready: 43, series_type: "some updated series_type", side_type: "some updated side_type", spectator_ids: [], start_time: "2011-05-18T15:01:01Z", status: "some updated status", team1_score: 43, team2_score: 43, title: "some updated title", veto_first: "some updated veto_first", veto_map_pool: []}
    @invalid_attrs %{api_key: nil, end_time: nil, enforce_teams: nil, max_maps: nil, min_player_ready: nil, series_type: nil, side_type: nil, spectator_ids: nil, start_time: nil, status: nil, team1_score: nil, team2_score: nil, title: nil, veto_first: nil, veto_map_pool: nil}

    def match_fixture(attrs \\ %{}) do
      {:ok, match} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Matches.create_match()

      match
    end

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert Matches.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Matches.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      assert {:ok, %Match{} = match} = Matches.create_match(@valid_attrs)
      assert match.api_key == "some api_key"
      assert match.end_time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert match.enforce_teams == true
      assert match.max_maps == 42
      assert match.min_player_ready == 42
      assert match.series_type == "some series_type"
      assert match.side_type == "some side_type"
      assert match.spectator_ids == []
      assert match.start_time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert match.status == "some status"
      assert match.team1_score == 42
      assert match.team2_score == 42
      assert match.title == "some title"
      assert match.veto_first == "some veto_first"
      assert match.veto_map_pool == []
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Matches.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()
      assert {:ok, %Match{} = match} = Matches.update_match(match, @update_attrs)
      assert match.api_key == "some updated api_key"
      assert match.end_time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert match.enforce_teams == false
      assert match.max_maps == 43
      assert match.min_player_ready == 43
      assert match.series_type == "some updated series_type"
      assert match.side_type == "some updated side_type"
      assert match.spectator_ids == []
      assert match.start_time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert match.status == "some updated status"
      assert match.team1_score == 43
      assert match.team2_score == 43
      assert match.title == "some updated title"
      assert match.veto_first == "some updated veto_first"
      assert match.veto_map_pool == []
    end

    test "update_match/2 with invalid data returns error changeset" do
      match = match_fixture()
      assert {:error, %Ecto.Changeset{}} = Matches.update_match(match, @invalid_attrs)
      assert match == Matches.get_match!(match.id)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = Matches.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Matches.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = Matches.change_match(match)
    end
  end
end
