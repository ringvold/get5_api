defmodule Get5Api.MapSelectionsTest do
  use Get5Api.DataCase

  alias Get5Api.MapSelections

  describe "map_selections" do
    alias Get5Api.MapSelections.MapSelection

    import Get5Api.MapSelectionsFixtures

    @invalid_attrs %{map_name: nil, pick_or_ban: nil, team_name: nil}

    test "list_map_selections/0 returns all map_selections" do
      map_selection = map_selection_fixture()
      assert MapSelections.list_map_selections() == [map_selection]
    end

    test "get_map_selection!/1 returns the map_selection with given id" do
      map_selection = map_selection_fixture()
      assert MapSelections.get_map_selection!(map_selection.id) == map_selection
    end

    test "create_map_selection/1 with valid data creates a map_selection" do
      valid_attrs = %{map_name: "de_nuke", pick_or_ban: :pick, team_name: "Team 1"}

      assert {:ok, %MapSelection{} = map_selection} = MapSelections.create_map_selection(valid_attrs)
      assert map_selection.map == "de_nuke"
      assert map_selection.pick_or_ban == :pick
      assert map_selection.team_name == "Team 1"
    end

    test "create_map_selection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MapSelections.create_map_selection(@invalid_attrs)
    end

    test "update_map_selection/2 with valid data updates the map_selection" do
      map_selection = map_selection_fixture()
      update_attrs = %{map_name: "some updated map", pick_or_ban: :ban, team_name: "some updated team_name"}

      assert {:ok, %MapSelection{} = map_selection} = MapSelections.update_map_selection(map_selection, update_attrs)
      assert map_selection.map == "some updated map"
      assert map_selection.pick_or_ban == :ban
      assert map_selection.team_name == "some updated team_name"
    end

    test "update_map_selection/2 with invalid data returns error changeset" do
      map_selection = map_selection_fixture()
      assert {:error, %Ecto.Changeset{}} = MapSelections.update_map_selection(map_selection, @invalid_attrs)
      assert map_selection == MapSelections.get_map_selection!(map_selection.id)
    end

    test "delete_map_selection/1 deletes the map_selection" do
      map_selection = map_selection_fixture()
      assert {:ok, %MapSelection{}} = MapSelections.delete_map_selection(map_selection)
      assert_raise Ecto.NoResultsError, fn -> MapSelections.get_map_selection!(map_selection.id) end
    end

    test "change_map_selection/1 returns a map_selection changeset" do
      map_selection = map_selection_fixture()
      assert %Ecto.Changeset{} = MapSelections.change_map_selection(map_selection)
    end
  end

  describe "side_selections" do
    alias Get5Api.MapSelections.SideSelection

    import Get5Api.MapSelectionsFixtures

    @invalid_attrs %{map_name: nil, side: nil, team_name: nil}

    test "list_side_selections/0 returns all side_selections" do
      side_selection = side_selection_fixture()
      assert MapSelections.list_side_selections() == [side_selection]
    end

    test "get_side_selection!/1 returns the side_selection with given id" do
      side_selection = side_selection_fixture()
      assert MapSelections.get_side_selection!(side_selection.id) == side_selection
    end

    test "create_side_selection/1 with valid data creates a side_selection" do
      valid_attrs = %{map_name: "de_nuke", side: "ct", team_name: "Team 1"}

      assert {:ok, %SideSelection{} = side_selection} = MapSelections.create_side_selection(valid_attrs)
      assert side_selection.map == "de_nuke"
      assert side_selection.side == "ct"
      assert side_selection.team_name == "Team 1"
    end

    test "create_side_selection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MapSelections.create_side_selection(@invalid_attrs)
    end

    test "update_side_selection/2 with valid data updates the side_selection" do
      side_selection = side_selection_fixture()
      update_attrs = %{map_name: "some updated map", side: "some updated side", team_name: "some updated team_name"}

      assert {:ok, %SideSelection{} = side_selection} = MapSelections.update_side_selection(side_selection, update_attrs)
      assert side_selection.map == "some updated map"
      assert side_selection.side == "some updated side"
      assert side_selection.team_name == "some updated team_name"
    end

    test "update_side_selection/2 with invalid data returns error changeset" do
      side_selection = side_selection_fixture()
      assert {:error, %Ecto.Changeset{}} = MapSelections.update_side_selection(side_selection, @invalid_attrs)
      assert side_selection == MapSelections.get_side_selection!(side_selection.id)
    end

    test "delete_side_selection/1 deletes the side_selection" do
      side_selection = side_selection_fixture()
      assert {:ok, %SideSelection{}} = MapSelections.delete_side_selection(side_selection)
      assert_raise Ecto.NoResultsError, fn -> MapSelections.get_side_selection!(side_selection.id) end
    end

    test "change_side_selection/1 returns a side_selection changeset" do
      side_selection = side_selection_fixture()
      assert %Ecto.Changeset{} = MapSelections.change_side_selection(side_selection)
    end
  end
end
