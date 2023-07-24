defmodule Get5ApiWeb.MatchController do
  use Get5ApiWeb, :controller

  alias Get5Api.Matches
  alias Get5Api.Matches.MatchConfigGenerator
  alias Get5Api.Stats
  alias Get5Api.SeriesEvents
  alias Get5Api.MapEvents

  import Jason.Helpers
  plug :authenticate_api_key

  action_fallback Get5ApiWeb.FallbackController

  def match_config(conn, _params) do
    match = conn.assigns.match

    match_config = MatchConfigGenerator.generate_config(match)
    render(conn, :match_config, match_config: match_config)
  end

  def events(conn, params) do
    match = conn.assigns.match

    case params["event"] do
      #
      # Series events
      #
      "match_config_load_fail" ->
        # TODO: Send message to clients on the match page
        conn
        |> put_status(:ok)

      "series_start" ->
        SeriesEvents.on_series_init(params, match)

        conn
        |> put_status(:ok)

      "series_end" ->
        case SeriesEvents.on_series_end(params, match) do
          {:ok, _match} ->
            conn
            |> put_status(:ok)

          {:error, changeset} ->
            {:error, %{changeset: changeset}}
        end

      "map_picked" ->
        case SeriesEvents.on_map_picked(params, match) do
          {:ok, _map_selection} ->
            conn
            |> put_status(:ok)

          {:error, changeset} ->
            {:error, %{changeset: changeset}}
        end

      "map_vetoed" ->
        case SeriesEvents.on_map_vetoed(params, match) do
          {:ok, _map_selection} ->
            conn
            |> put_status(:ok)

          {:error, changeset} ->
            {:error, %{changeset: changeset}}
        end

      "side_picked" ->
        case SeriesEvents.on_side_picked(params, match) do
          {:ok, side_selection} ->
            conn
            |> put_status(:ok)

          {:error, changeset} ->
            {:error, %{changeset: changeset}}
        end

      #
      # Map events
      #
      "going_live" ->
        case MapEvents.on_going_live(params, match) do
          {:ok, map_stats} ->
            conn
            |> put_status(:ok)

          {:error, changeset} ->
            {:error, %{changeset: changeset}}
        end

      "map_result" ->
        case SeriesEvents.on_map_result(params, match) do
          {:ok, _results} ->
            conn
            |> put_status(:ok)

          {:error, failed_operation, failed_value, _changes_so_far} ->
            {:error, %{failed_operation: failed_operation, failed_value: failed_value}}
        end

      #
      # Live events goes here (ex: player death, bomb defused, round end)
      #
      _ ->
        # Ignore other events
        conn
        |> put_status(:ok)
        |> json(:ok)
    end
  end

  defp authenticate_api_key(conn, _options) do
    match = Matches.get_match!(conn.params["id"] || conn.params["matchid"])

    case get_req_header(conn, "authorization") do
      [header] ->
        api_key = String.trim_leading(header, "Bearer ")

        if api_key != match.api_key do
          conn
          |> put_status(:unauthorized)
          |> json(
            json_map(
              errors:
                json_map(detail: Phoenix.Controller.status_message_from_template("401.json"))
            )
          )
          |> halt()
        else
          assign(conn, :match, match)
        end

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(
          json_map(
            errors: json_map(detail: Phoenix.Controller.status_message_from_template("400.json"))
          )
        )
        |> halt()
    end
  end
end
