defmodule Get5Api.MatchesTest do
  use Get5Api.DataCase

  alias Get5Api.Matches

  describe "matches" do
    alias Get5Api.Matches.Match

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

    @valid_attrs %{
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
      veto_map_pool: ["de_dust"],
      team1_score: 0,
      team2_score: 0,
      team1: @team1,
      team2: @team2
    }
    @update_attrs %{
      end_time: "2011-05-18T15:01:01Z",
      enforce_teams: false,
      min_player_ready: 5,
      series_type: :bo1,
      side_type: :standard,
      spectator_ids: [],
      start_time: "2011-05-18T15:01:01Z",
      status: "some updated status",
      title: "some updated title",
      team1_score: 0,
      team2_score: 0,
      veto_first: "some updated veto_first",
      veto_map_pool: ["de_inferno"]
    }
    @invalid_attrs %{
      api_key: nil,
      end_time: nil,
      enforce_teams: nil,
      max_maps: nil,
      min_player_ready: nil,
      series_type: nil,
      side_type: nil,
      spectator_ids: nil,
      start_time: nil,
      status: nil,
      title: nil,
      veto_first: nil,
      veto_map_pool: nil
    }

    def match_fixture(_state \\ %{}, attrs \\ %{}) do
      {:ok, match} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Matches.create_match()

      match
    end

    test "list_matches/0 returns all matches" do
      match_fixture()
      assert length(Matches.list_matches()) == 1
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Matches.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      assert {:ok, %Match{} = match} = Matches.create_match(@valid_attrs)
      assert match.enforce_teams == true
      assert match.min_player_ready == 5
      assert match.series_type == :bo1
      assert match.side_type == :standard
      assert match.spectator_ids == []
      assert match.status == "some status"
      assert match.title == "some title"
      assert match.veto_first == "some veto_first"
      assert match.veto_map_pool == ["de_dust"]
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Matches.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()
      assert {:ok, %Match{} = match} = Matches.update_match(match, @update_attrs)
      assert match.enforce_teams == false
      assert match.min_player_ready == 5
      assert match.series_type == :bo1
      assert match.side_type == :standard
      assert match.spectator_ids == []
      assert match.title == "some updated title"
      assert match.veto_first == "some updated veto_first"
      assert match.veto_map_pool == ["de_inferno"]
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

  # describe "matches" do
  #   alias Get5Api.Matches.Match

  #   import Get5Api.MatchesFixtures

  #   @invalid_attrs %{api_key: nil, series_type: nil, side_type: nil, veto_map_pool: nil}

  #   test "list_matches/0 returns all matches" do
  #     match = match_fixture()
  #     assert Matches.list_matches() == [match]
  #   end

  #   test "get_match!/1 returns the match with given id" do
  #     match = match_fixture()
  #     assert Matches.get_match!(match.id) == match
  #   end

  #   test "create_match/1 with valid data creates a match" do
  #     valid_attrs = %{api_key: "some api_key", series_type: :bo1_preset, side_type: :standard, veto_map_pool: []}

  #     assert {:ok, %Match{} = match} = Matches.create_match(valid_attrs)
  #     assert match.api_key == "some api_key"
  #     assert match.series_type == :bo1_preset
  #     assert match.side_type == :standard
  #     assert match.veto_map_pool == []
  #   end

  #   test "create_match/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Matches.create_match(@invalid_attrs)
  #   end

  #   test "update_match/2 with valid data updates the match" do
  #     match = match_fixture()
  #     update_attrs = %{api_key: "some updated api_key", series_type: :bo1, side_type: :always_knife, veto_map_pool: []}

  #     assert {:ok, %Match{} = match} = Matches.update_match(match, update_attrs)
  #     assert match.api_key == "some updated api_key"
  #     assert match.series_type == :bo1
  #     assert match.side_type == :always_knife
  #     assert match.veto_map_pool == []
  #   end

  #   test "update_match/2 with invalid data returns error changeset" do
  #     match = match_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Matches.update_match(match, @invalid_attrs)
  #     assert match == Matches.get_match!(match.id)
  #   end

  #   test "delete_match/1 deletes the match" do
  #     match = match_fixture()
  #     assert {:ok, %Match{}} = Matches.delete_match(match)
  #     assert_raise Ecto.NoResultsError, fn -> Matches.get_match!(match.id) end
  #   end

  #   test "change_match/1 returns a match changeset" do
  #     match = match_fixture()
  #     assert %Ecto.Changeset{} = Matches.change_match(match)
  #   end
  # end
end
