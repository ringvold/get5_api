defmodule Get5Api.SeriesEvents do
  alias Get5Api.GameServers
  alias Get5Api.MapSelections
  alias Get5Api.Matches
  alias Get5Api.Matches.Match
  alias Get5Api.Stats

  @type on_map_picked() :: %{
          # event: "map_picked"
          event: String.t(),
          matchid: String.t(),
          team: String.t(),
          map_name: String.t(),
          map_number: integer()
        }
  @type on_map_vetoed() :: %{
          # event: "map_vetoed"
          event: String.t(),
          matchid: String.t(),
          team: String.t(),
          map_name: String.t()
        }
  @type on_backup_restore() :: %{
          # event: "backup_loaded"
          event: String.t(),
          matchid: String.t(),
          map_number: integer(),
          round_number: integer(),
          filename: String.t()
        }

  def on_series_init(_event, match) do
    Matches.update_match(match, %{start_time: DateTime.utc_now()})
    GameServers.update_game_server(match.game_server, %{in_use: true})
  end

  def on_map_result(event, match) do
    Stats.store_map_result(match, event)
  end

  def on_series_end(event, match) do
    Matches.update_match(match, %{
      team1_score: event["team1_series_score"],
      team2_score: event["team2_series_score"],
      winner_id: Stats.get_winner_id(event)
    })

    GameServers.update_game_server(match.game_server, %{in_use: false})
  end

  @spec on_map_picked(on_map_picked(), %Match{}) :: any()
  def on_map_picked(event, match) do
    team_name = get_team_name(event.team, match)
    # TODO: broadcast map pick
    MapSelections.create_map_selection(%{
      match_id: match.id,
      team_name: team_name,
      map_name: event.map_name,
      pick_or_ban: :pick
    })
    Matches.update_match(match, %{status: :finished})
  end

  @spec on_map_vetoed(on_map_vetoed(), %Match{}) :: any()
  def on_map_vetoed(event, match) do
    team_name = get_team_name(event.team, match)
    # TODO: broadcast map veto
    MapSelections.create_map_selection(%{
      match_id: match.id,
      team_name: team_name,
      map_name: event.map_name,
      pick_or_ban: :ban
    })
  end

  defp get_team_name(team, match) do
    case team do
      "team1" ->
        match.team1.name

      "team2" ->
        match.team2.name

      _ ->
        "Decider"
    end
  end

  def on_side_picked(event, match) do
    # No side was chosen, perhaps was default? Ignore the event.

    # Need to get the initial veto data to link back to the veto table.
    # If team1 is picking sides, that means team2 picked the map.
    :not_implemented
  end

  @spec on_backup_restore(on_backup_restore(), %Match{}) :: any()
  def on_backup_restore(_event, _match) do
    # Remember to delete stats for later rounds than the one being restored
    :not_implemented
  end
end
