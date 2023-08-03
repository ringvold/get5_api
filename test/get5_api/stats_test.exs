defmodule Get5Api.StatsTest do
  use Get5Api.DataCase

  alias Get5Api.Stats

  describe "map_stats" do
    alias Get5Api.Stats.MapStats

    import Get5Api.StatsFixtures

    @invalid_attrs %{end_time: nil, map_name: nil, map_number: nil, start_time: nil, team1_score: nil, team2_score: nil}

    test "list_map_stats/0 returns all map_stats" do
      map_stats = map_stats_fixture()
      assert Stats.list_map_stats() == [map_stats]
    end

    test "get_map_stats!/1 returns the map_stats with given id" do
      map_stats = map_stats_fixture()
      assert Stats.get_map_stats!(map_stats.id) == map_stats
    end

    test "create_map_stats/1 with valid data creates a map_stats" do
      valid_attrs = %{end_time: ~U[2023-07-18 20:50:00Z], map_name: "some map_name", map_number: 42, start_time: ~U[2023-07-18 20:50:00Z], team1_score: 42, team2_score: "some team2_score"}

      assert {:ok, %MapStats{} = map_stats} = Stats.create_map_stats(valid_attrs)
      assert map_stats.end_time == ~U[2023-07-18 20:50:00Z]
      assert map_stats.map_name == "some map_name"
      assert map_stats.map_number == 42
      assert map_stats.start_time == ~U[2023-07-18 20:50:00Z]
      assert map_stats.team1_score == 42
      assert map_stats.team2_score == "some team2_score"
    end

    test "create_map_stats/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stats.create_map_stats(@invalid_attrs)
    end

    test "update_map_stats/2 with valid data updates the map_stats" do
      map_stats = map_stats_fixture()
      update_attrs = %{end_time: ~U[2023-07-19 20:50:00Z], map_name: "some updated map_name", map_number: 43, start_time: ~U[2023-07-19 20:50:00Z], team1_score: 43, team2_score: "some updated team2_score"}

      assert {:ok, %MapStats{} = map_stats} = Stats.update_map_stats(map_stats, update_attrs)
      assert map_stats.end_time == ~U[2023-07-19 20:50:00Z]
      assert map_stats.map_name == "some updated map_name"
      assert map_stats.map_number == 43
      assert map_stats.start_time == ~U[2023-07-19 20:50:00Z]
      assert map_stats.team1_score == 43
      assert map_stats.team2_score == "some updated team2_score"
    end

    test "update_map_stats/2 with invalid data returns error changeset" do
      map_stats = map_stats_fixture()
      assert {:error, %Ecto.Changeset{}} = Stats.update_map_stats(map_stats, @invalid_attrs)
      assert map_stats == Stats.get_map_stats!(map_stats.id)
    end

    test "delete_map_stats/1 deletes the map_stats" do
      map_stats = map_stats_fixture()
      assert {:ok, %MapStats{}} = Stats.delete_map_stats(map_stats)
      assert_raise Ecto.NoResultsError, fn -> Stats.get_map_stats!(map_stats.id) end
    end

    test "change_map_stats/1 returns a map_stats changeset" do
      map_stats = map_stats_fixture()
      assert %Ecto.Changeset{} = Stats.change_map_stats(map_stats)
    end
  end

  describe "player_stats" do
    alias Get5Api.Stats.PlayerStats

    import Get5Api.StatsFixtures

    @invalid_attrs %{"2k": nil, flash_assists: nil, rounds_played: nil, first_deaths_ct: nil, headshot_kills: nil, suicides: nil, "3k": nil, score: nil, "4k": nil, assists: nil, bomb_defuses: nil, bomb_plants: nil, friendlies_flashed: nil, trade_kills: nil, deaths: nil, first_kills_t: nil, first_deaths_t: nil, first_kills_ct: nil, "1v3": nil, knife_kills: nil, mvp: nil, "1v4": nil, "1k": nil, "5k": nil, kast: nil, "1v5": nil, utility_damage: nil, kill: nil, enemies_flashed: nil, team_kills: nil, "1v1": nil, damage: nil, "1v2": nil}

    test "list_player_stats/0 returns all player_stats" do
      player_stats = player_stats_fixture()
      assert Stats.list_player_stats() == [player_stats]
    end

    test "get_player_stats!/1 returns the player_stats with given id" do
      player_stats = player_stats_fixture()
      assert Stats.get_player_stats!(player_stats.id) == player_stats
    end

    test "create_player_stats/1 with valid data creates a player_stats" do
      valid_attrs = %{"2k": 42, flash_assists: 42, rounds_played: 42, first_deaths_ct: "some first_deaths_ct", headshot_kills: 42, suicides: 42, "3k": 42, score: 42, "4k": 42, assists: 42, bomb_defuses: 42, bomb_plants: 42, friendlies_flashed: 42, trade_kills: 42, deaths: 42, first_kills_t: 42, first_deaths_t: 42, first_kills_ct: 42, "1v3": 42, knife_kills: 42, mvp: 42, "1v4": 42, "1k": 42, "5k": 42, kast: 42, "1v5": 42, utility_damage: 42, kill: 42, enemies_flashed: 42, team_kills: 42, "1v1": 42, damage: 42, "1v2": 42}

      assert {:ok, %PlayerStats{} = player_stats} = Stats.create_player_stats(valid_attrs)
      assert player_stats."1v2" == 42
      assert player_stats.damage == 42
      assert player_stats."1v1" == 42
      assert player_stats.team_kills == 42
      assert player_stats.enemies_flashed == 42
      assert player_stats.kill == 42
      assert player_stats.utility_damage == 42
      assert player_stats."1v5" == 42
      assert player_stats.kast == 42
      assert player_stats."5k" == 42
      assert player_stats."1k" == 42
      assert player_stats."1v4" == 42
      assert player_stats.mvp == 42
      assert player_stats.knife_kills == 42
      assert player_stats."1v3" == 42
      assert player_stats.first_kills_ct == 42
      assert player_stats.first_deaths_t == 42
      assert player_stats.first_kills_t == 42
      assert player_stats.deaths == 42
      assert player_stats.trade_kills == 42
      assert player_stats.friendlies_flashed == 42
      assert player_stats.bomb_plants == 42
      assert player_stats.bomb_defuses == 42
      assert player_stats.assists == 42
      assert player_stats."4k" == 42
      assert player_stats.score == 42
      assert player_stats."3k" == 42
      assert player_stats.suicides == 42
      assert player_stats.headshot_kills == 42
      assert player_stats.first_deaths_ct == "some first_deaths_ct"
      assert player_stats.rounds_played == 42
      assert player_stats.flash_assists == 42
      assert player_stats."2k" == 42
    end

    test "create_player_stats/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stats.create_player_stats(@invalid_attrs)
    end

    test "update_player_stats/2 with valid data updates the player_stats" do
      player_stats = player_stats_fixture()
      update_attrs = %{"2k": 43, flash_assists: 43, rounds_played: 43, first_deaths_ct: "some updated first_deaths_ct", headshot_kills: 43, suicides: 43, "3k": 43, score: 43, "4k": 43, assists: 43, bomb_defuses: 43, bomb_plants: 43, friendlies_flashed: 43, trade_kills: 43, deaths: 43, first_kills_t: 43, first_deaths_t: 43, first_kills_ct: 43, "1v3": 43, knife_kills: 43, mvp: 43, "1v4": 43, "1k": 43, "5k": 43, kast: 43, "1v5": 43, utility_damage: 43, kill: 43, enemies_flashed: 43, team_kills: 43, "1v1": 43, damage: 43, "1v2": 43}

      assert {:ok, %PlayerStats{} = player_stats} = Stats.update_player_stats(player_stats, update_attrs)
      assert player_stats."1v2" == 43
      assert player_stats.damage == 43
      assert player_stats."1v1" == 43
      assert player_stats.team_kills == 43
      assert player_stats.enemies_flashed == 43
      assert player_stats.kill == 43
      assert player_stats.utility_damage == 43
      assert player_stats."1v5" == 43
      assert player_stats.kast == 43
      assert player_stats."5k" == 43
      assert player_stats."1k" == 43
      assert player_stats."1v4" == 43
      assert player_stats.mvp == 43
      assert player_stats.knife_kills == 43
      assert player_stats."1v3" == 43
      assert player_stats.first_kills_ct == 43
      assert player_stats.first_deaths_t == 43
      assert player_stats.first_kills_t == 43
      assert player_stats.deaths == 43
      assert player_stats.trade_kills == 43
      assert player_stats.friendlies_flashed == 43
      assert player_stats.bomb_plants == 43
      assert player_stats.bomb_defuses == 43
      assert player_stats.assists == 43
      assert player_stats."4k" == 43
      assert player_stats.score == 43
      assert player_stats."3k" == 43
      assert player_stats.suicides == 43
      assert player_stats.headshot_kills == 43
      assert player_stats.first_deaths_ct == "some updated first_deaths_ct"
      assert player_stats.rounds_played == 43
      assert player_stats.flash_assists == 43
      assert player_stats."2k" == 43
    end

    test "update_player_stats/2 with invalid data returns error changeset" do
      player_stats = player_stats_fixture()
      assert {:error, %Ecto.Changeset{}} = Stats.update_player_stats(player_stats, @invalid_attrs)
      assert player_stats == Stats.get_player_stats!(player_stats.id)
    end

    test "delete_player_stats/1 deletes the player_stats" do
      player_stats = player_stats_fixture()
      assert {:ok, %PlayerStats{}} = Stats.delete_player_stats(player_stats)
      assert_raise Ecto.NoResultsError, fn -> Stats.get_player_stats!(player_stats.id) end
    end

    test "change_player_stats/1 returns a player_stats changeset" do
      player_stats = player_stats_fixture()
      assert %Ecto.Changeset{} = Stats.change_player_stats(player_stats)
    end
  end
end
