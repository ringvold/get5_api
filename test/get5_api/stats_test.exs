defmodule Get5Api.StatsTest do
  use Get5Api.DataCase

  alias Get5Api.Stats

  describe "match_stats" do
    alias Get5Api.Stats.MatchStats

    import Get5Api.StatsFixtures

    @invalid_attrs %{end_time: nil, map_name: nil, map_number: nil, start_time: nil, team1_score: nil, team2_score: nil}

    test "list_match_stats/0 returns all match_stats" do
      match_stats = match_stats_fixture()
      assert Stats.list_match_stats() == [match_stats]
    end

    test "get_match_stats!/1 returns the match_stats with given id" do
      match_stats = match_stats_fixture()
      assert Stats.get_match_stats!(match_stats.id) == match_stats
    end

    test "create_match_stats/1 with valid data creates a match_stats" do
      valid_attrs = %{end_time: ~U[2023-03-16 19:45:00Z], map_name: "some map_name", map_number: 42, start_time: ~U[2023-03-16 19:45:00Z], team1_score: 42, team2_score: "some team2_score"}

      assert {:ok, %MatchStats{} = match_stats} = Stats.create_match_stats(valid_attrs)
      assert match_stats.end_time == ~U[2023-03-16 19:45:00Z]
      assert match_stats.map_name == "some map_name"
      assert match_stats.map_number == 42
      assert match_stats.start_time == ~U[2023-03-16 19:45:00Z]
      assert match_stats.team1_score == 42
      assert match_stats.team2_score == "some team2_score"
    end

    test "create_match_stats/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stats.create_match_stats(@invalid_attrs)
    end

    test "update_match_stats/2 with valid data updates the match_stats" do
      match_stats = match_stats_fixture()
      update_attrs = %{end_time: ~U[2023-03-17 19:45:00Z], map_name: "some updated map_name", map_number: 43, start_time: ~U[2023-03-17 19:45:00Z], team1_score: 43, team2_score: "some updated team2_score"}

      assert {:ok, %MatchStats{} = match_stats} = Stats.update_match_stats(match_stats, update_attrs)
      assert match_stats.end_time == ~U[2023-03-17 19:45:00Z]
      assert match_stats.map_name == "some updated map_name"
      assert match_stats.map_number == 43
      assert match_stats.start_time == ~U[2023-03-17 19:45:00Z]
      assert match_stats.team1_score == 43
      assert match_stats.team2_score == "some updated team2_score"
    end

    test "update_match_stats/2 with invalid data returns error changeset" do
      match_stats = match_stats_fixture()
      assert {:error, %Ecto.Changeset{}} = Stats.update_match_stats(match_stats, @invalid_attrs)
      assert match_stats == Stats.get_match_stats!(match_stats.id)
    end

    test "delete_match_stats/1 deletes the match_stats" do
      match_stats = match_stats_fixture()
      assert {:ok, %MatchStats{}} = Stats.delete_match_stats(match_stats)
      assert_raise Ecto.NoResultsError, fn -> Stats.get_match_stats!(match_stats.id) end
    end

    test "change_match_stats/1 returns a match_stats changeset" do
      match_stats = match_stats_fixture()
      assert %Ecto.Changeset{} = Stats.change_match_stats(match_stats)
    end
  end
end
