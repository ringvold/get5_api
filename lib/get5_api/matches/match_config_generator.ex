defmodule Get5Api.Matches.MatchConfigGenerator do
  alias Get5Api.Matches.Match

  @doc """
  Generates json config for a match

  From the Get5 documentation about matchid:
  The ID of the match. This determines the matchid parameter in all forwards and
  events. If you use the MySQL extension, you should leave this field blank
  (or omit it), as match IDs will be assigned automatically. If you do want to
  assign match IDs from another source, they **must** be integers (in a string) and
  must increment between matches.
  """
  @spec generate_config(%Match{}, String.t()) :: map()
  def generate_config(match, base_url) do
    %{
      matchid: Integer.to_string(match.id),
      maplist: match.map_list,
      num_maps: Match.series_type_to_max_maps(match.series_type)
    }
    |> with_team(:team1, match.team1)
    |> with_team(:team2, match.team2)
    |> with_cvars(match, base_url)
  end

  def with_team(map, field, team) do
    Map.put(map, field, %{
      id: "#{team.id}",
      name: team.name,
      players:
        team.players
        |> Enum.into(
          %{},
          fn player ->
            if player.name != nil do
              {"#{player.steam_id}", player.name}
            else
              {"#{player.steam_id}", ""}
            end
          end
        )
    })
  end

  def with_cvars(map, match, base_url) do
    Map.put(map, :cvars, %{
      get5_remote_log_url: "#{base_url}/matches/#{match.id}/events",
      get5_remote_log_header_key: "Authorization",
      get5_remote_log_header_value: "Bearer #{match.api_key}"
    })
  end
end
