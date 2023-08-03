defmodule Get5Api.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Get5Api.Teams` context.
  """

  @doc """
  Generate a team.
  """
def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "Some Great Team",
        players: %{}
      })
      |> Get5Api.Teams.create_team()

    team
  end

  def team1_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "Team 1",
        players: %{}
      })
      |> Get5Api.Teams.create_team()

    team
  end

  def team2_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "Team 2",
        players: %{}
      })
      |> Get5Api.Teams.create_team()

    team
  end
end
