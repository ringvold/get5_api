defmodule Get5Api.MapSelectionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Get5Api.MapSelections` context.
  """

  @doc """
  Generate a map_selection.
  """
  def map_selection_fixture(attrs \\ %{}) do
    {:ok, map_selection} =
      attrs
      |> Enum.into(%{
        map_name: "de_nuke",
        pick_or_ban: :pick,
        team_name: "Team 1"
      })
      |> Get5Api.MapSelections.create_map_selection()

    map_selection
  end

  @doc """
  Generate a side_selection.
  """
  def side_selection_fixture(attrs \\ %{}) do
    {:ok, side_selection} =
      attrs
      |> Enum.into(%{
        map_name: "de_nuke",
        side: "ct",
        team_name: "Team 1"
      })
      |> Get5Api.MapSelections.create_side_selection()

    side_selection
  end
end
