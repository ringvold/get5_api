defmodule Get5Api.MatchesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Get5Api.Matches` context.
  """

  @doc """
  Generate a match.
  """
  def match_fixture(attrs \\ %{}) do
    {:ok, match} =
      attrs
      |> Enum.into(%{
        api_key: "some api_key",
        series_type: :bo1_preset,
        side_type: :standard,
        veto_map_pool: []
      })
      |> Get5Api.Matches.create_match()

    match
  end
end
