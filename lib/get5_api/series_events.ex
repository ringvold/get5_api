defmodule Get5Api.SeriesEvents do
  alias Get5Api.GameServers
  alias Get5Api.Matches
  alias Get5Api.Stats

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
end
