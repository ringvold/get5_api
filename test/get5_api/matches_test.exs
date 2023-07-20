defmodule Get5Api.MatchesTest do
  use Get5Api.DataCase

  alias Get5Api.Matches
  import Get5Api.GameServersFixtures
  import Get5Api.TeamsFixtures

  describe "matches" do
    alias Get5Api.Matches.Match
    alias Get5Api.Teams.Player


    @game_server_attrs %{
      id: 1,
      host: "csgo.example.com",
      in_use: true,
      name: "some name",
      port: 27015,
      gotv_port: 27020,
      rcon_password: "some rcon_password"
    }
    @team1_attrs %{
      id: 1,
      name: "Team1",
      players: []
    }
    @team2_attrs %{
      id: 2,
      name: "Team2",
      players: []

    }

    @valid_attrs %{
      api_key: "some_api_key",
      end_time: "2010-04-17T14:00:00Z",
      enforce_teams: true,
      min_player_ready: 5,
      series_type: :bo1,
      side_type: :standard,
      spectator_ids: [],
      start_time: "2010-04-17T14:00:00Z",
      status: :pending,
      title: "some title",
      veto_first: :team1,
      map_list: ["de_dust"],
      team1_score: 0,
      team2_score: 0,
      game_server_id: @game_server_attrs.id,
      team1_id: @team1_attrs.id,
      team2_id: @team2_attrs.id,
      # game_server: @game_server_attrs,
      # team1_id: @team1_attrs,
      # team2_id: @team2_attrs
    }
    @update_attrs %{
      end_time: "2011-05-18T15:01:01Z",
      enforce_teams: false,
      min_player_ready: 5,
      series_type: :bo1,
      side_type: :standard,
      spectator_ids: [],
      start_time: "2011-05-18T15:01:01Z",
      status: :live,
      title: "some updated title",
      team1_score: 1,
      team2_score: 2,
      veto_first: :team2,
      map_list: ["de_inferno"]
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
      map_list: nil
    }

    def match_fixture(_state \\ %{}, attrs \\ %{}) do
      game_server=game_server_fixture(@game_server_attrs)
      team1=team1_fixture(@team1_attrs)
      team2=team2_fixture(@team2_attrs)
      {:ok, match} =
        %{game_server_id: game_server.id, team1_id: team1.id,team2_id: team2.id}
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
      game_server=game_server_fixture(@game_server_attrs)
      team1=team1_fixture(@team1_attrs)
      team2=team2_fixture(@team2_attrs)
      assert {:ok, %Match{} = match} = Matches.create_match(
        %{game_server_id: game_server.id, team1_id: team1.id,team2_id: team2.id}
        |> Enum.into(@valid_attrs)
        )
      assert match.enforce_teams == true
      assert match.min_player_ready == 5
      assert match.series_type == :bo1
      assert match.side_type == :standard
      assert match.spectator_ids == []
      assert match.status == :pending
      assert match.title == "some title"
      assert match.veto_first == :team1
      assert match.map_list == ["de_dust"]
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
      assert match.status == :live
      assert match.veto_first == :team2
      assert match.map_list == ["de_inferno"]
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
