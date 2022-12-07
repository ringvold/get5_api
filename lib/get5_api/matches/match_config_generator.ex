defmodule Get5Api.Matches.MatchConfigGenerator do
  alias Get5Api.Matches.Match

  @doc """
  Generates json config for a match
  """
  @spec generate_config(%Match{}) :: map()
  def generate_config(match) do
    %{
      id: match.id,
      series_type: match.series_type,
      veto_map_pool: match.veto_map_pool
    }
    |> with_team(:team1, match.team1)
    |> with_team(:team2, match.team2)
  end

  def with_team(map, field, team) do
    Map.put(map, field, %{name: team.name, players: team.players})
  end
end
