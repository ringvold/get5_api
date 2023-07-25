defmodule Get5Api.MapEvents do
  alias Get5Api.Matches
  alias Get5Api.Matches.Match
  alias Get5Api.Stats
  alias Get5Api.MapSelections

  @type on_going_live() :: %{event: String.t(), matchid: String.t(), map_number: integer()}

  @spec on_going_live(on_going_live(), %Match{}) :: any()
  def on_going_live(event, match) do
    # When we have veto/map ban info use that to get map name
    # or get it from map_list in match

    # Check if map_stats exists for match_id and map_number
    case Stats.get_by_match_and_map_number(match.id, event["map_number"]) do
      nil ->
        Stats.create_map_stats(%{match_id: match.id, start_time: DateTime.utc_now()})

      map_stat ->
        Stats.update_map_stats(
          map_stat,
          %{map_number: event["map_number"], start_time: DateTime.utc_now()}
        )
    end
    Matches.update_match(match, %{status: :live})
  end
end
