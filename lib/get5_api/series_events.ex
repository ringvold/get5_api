defmodule Get5Api.SeriesEvents do
  alias Get5Api.GameServers
  alias Get5Api.MapSelections
  alias Get5Api.Matches
  alias Get5Api.Matches.Match
  alias Get5Api.Stats

  @moduledoc """
  This module handles events related to series, such as map picks, map results, and series results.

  It provides functions to process these events and update the match state accordingly.

  Events documentation: https://shobhit-pathak.github.io/MatchZy/events.html
  """

  @typedoc """
  event: map_picked
  """
  @type on_map_picked() :: %{
          event: String.t(),
          matchid: integer(),
          team: String.t(),
          map_name: String.t(),
          map_number: integer()
        }

  @typedoc """
  event: map_vetoed
  """
  @type on_map_vetoed() :: %{
          event: String.t(),
          matchid: integer(),
          team: String.t(),
          map_name: String.t()
        }

  @typedoc """
  event: backup_loaded
  """
  @type on_backup_restore() :: %{
          event: String.t(),
          matchid: integer(),
          map_number: integer(),
          round_number: integer(),
          filename: String.t()
        }

  @typedoc """
  event: series_start
  """
  @type on_series_start() :: %{
          event: String.t(),
          matchid: integer(),
          num_maps: integer(),
          team1: %{
            id: String.t(),
            name: String.t()
          },
          team2: %{
            id: String.t(),
            name: String.t()
          }
        }

  @type player_stats() :: %{
          kills: integer(),
          deaths: integer(),
          assists: integer(),
          flash_assists: integer(),
          team_kills: integer(),
          suicides: integer(),
          damage: integer(),
          utility_damage: integer(),
          enemies_flashed: integer(),
          friendlies_flashed: integer(),
          knife_kills: integer(),
          headshot_kills: integer(),
          rounds_played: integer(),
          bomb_defuses: integer(),
          bomb_plants: integer(),
          "1k": integer(),
          "2k": integer(),
          "3k": integer(),
          "4k": integer(),
          "5k": integer(),
          "1v1": integer(),
          "1v2": integer(),
          "1v3": integer(),
          "1v4": integer(),
          "1v5": integer(),
          first_kills_t: integer(),
          first_kills_ct: integer(),
          first_deaths_t: integer(),
          first_deaths_ct: integer(),
          trade_kills: integer(),
          kast: integer(),
          score: integer(),
          mvp: integer()
        }

  @typedoc """
  event: map_result
  """
  @type on_map_result() :: %{
          event: String.t(),
          matchid: integer(),
          map_number: integer(),
          team1: %{
            id: String.t(),
            name: String.t(),
            series_score: integer(),
            score: integer(),
            score_ct: integer(),
            score_t: integer(),
            players:
              list(%{
                steamid: String.t(),
                name: String.t(),
                stats: player_stats()
              }),
            side: String.t(),
            starting_side: String.t()
          },
          team2: %{
            id: String.t(),
            name: String.t(),
            series_score: integer(),
            score: integer(),
            score_ct: integer(),
            score_t: integer(),
            players:
              list(%{
                steamid: String.t(),
                name: String.t(),
                stats: player_stats()
              }),
            side: String.t(),
            starting_side: String.t()
          },
          winner: %{
            side: String.t(),
            team: String.t()
          }
        }

  @typedoc """
  event: series_result
  """
  @type on_series_result() :: %{
          event: String.t(),
          matchid: integer(),
          team1_series_score: integer(),
          team2_series_score: integer(),
          winner: %{
            side: String.t(),
            team: String.t()
          },
          time_until_restore: integer()
        }

  @spec on_series_init(event :: on_series_start(), match :: %Match{}) :: any()
  def on_series_init(_event, match) do
    Matches.update_match(match, %{start_time: DateTime.utc_now()})
    GameServers.update_game_server(match.game_server, %{in_use: true})
  end

  @spec on_map_result(event :: on_map_result(), match :: %Match{}) :: any()
  def on_map_result(event, match) do
    Stats.store_map_result(match, event)
  end

  @spec on_series_result(event :: on_series_result(), match :: %Match{}) :: any()
  def on_series_result(event, match) do
    Matches.update_match(match, %{
      team1_score: event["team1_series_score"],
      team2_score: event["team2_series_score"],
      winner_id: get_winner_id(event, match),
      end_time: DateTime.utc_now(),
      # TODO: some more checks here for if it was cancelled
      status: :finished
    })

    GameServers.update_game_server(match.game_server, %{in_use: false})
  end

  defp get_winner_id(event, match) do
    case event["winner"]["team"] do
      "team1" -> match.team1_id
      "team2" -> match.team2_id
      _ -> nil
    end
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
    if event["side"] == nil do
      {:ok, :ignored}
    else
      teams =
        if event["team"] == "team1" do
          %{pick_team: match.team1, ban_team: match.team2}
        else
          %{pick_team: match.team2, ban_team: match.team1}
        end

      map_selection =
        MapSelections.get_picked_map(match.id, teams.pick_team.name, event["map_name"])

      side =
        case event["side"] do
          "t" -> :t
          "ct" -> :ct
        end

      MapSelections.create_side_selection(%{
        match_id: match.id,
        map_selection_id: map_selection.id,
        team_name: teams.pick_team.name,
        map_name: event["map_name"],
        side: side
      })
    end
  end

  @spec on_backup_restore(on_backup_restore(), %Match{}) :: any()
  def on_backup_restore(_event, _match) do
    # Remember to delete stats for later rounds than the one being restored
    :not_implemented
  end

  @type on_round_end() :: %{
          event: String.t(),
          matchid: integer(),
          map_number: integer(),
          round_number: integer(),
          round_time: integer(),
          reason: integer(),
          winner: %{
            side: String.t(),
            team: String.t()
          },
          team1: %{
            id: String.t(),
            name: String.t(),
            score: integer(),
            score_ct: integer(),
            score_t: integer(),
            players:
              list(%{
                steamid: String.t(),
                name: String.t(),
                stats: player_stats()
              }),
            side: String.t(),
            starting_side: String.t()
          },
          team2: %{
            id: String.t(),
            name: String.t(),
            score: integer(),
            score_ct: integer(),
            score_t: integer(),
            players:
              list(%{
                steamid: String.t(),
                name: String.t(),
                stats: player_stats()
              }),
            side: String.t(),
            starting_side: String.t()
          }
        }
end
