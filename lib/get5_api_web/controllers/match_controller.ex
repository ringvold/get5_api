defmodule Get5ApiWeb.MatchController do
  use Get5ApiWeb, :controller

  alias Get5Api.Matches
  alias Get5Api.Matches.MatchConfigGenerator
  alias Get5Api.Stats
  import Jason.Helpers
  plug :authenticate_api_key when action not in [:events]

  action_fallback Get5ApiWeb.FallbackController

  def match_config(conn, _params) do
    match = conn.assigns.match

    match_config = MatchConfigGenerator.generate_config(match)
    render(conn, :match_config, match_config: match_config)
  end

  def events(conn, params) do
    # TODO: Fix api key auth
    match = Matches.get_match!(params["matchid"])

    case params["event"] do
      "series_start" ->
        case Matches.update_match(match, %{start_time: DateTime.utc_now()}) do
          {:ok, _match} ->
            conn
            |> put_status(:ok)

          {:error, changeset} ->
            {:error, %{changeset: changeset}}
        end

      "map_result" ->
        case Stats.store_map_result(match, params) do
          {:ok, _results} ->
            conn
            |> put_status(:ok)

          {:error, failed_operation, failed_value, _changes_so_far} ->
            {:error, %{failed_operation: failed_operation, failed_value: failed_value}}
        end

      "series_end" ->
        case Matches.update_match(match, %{
               team1_score: params["team1_series_score"],
               team2_score: params["team2_series_score"],
               winner_id: Stats.get_winner_id(params)
             }) do
          {:ok, _match} ->
            conn
            |> put_status(:ok)

          {:error, changeset} ->
            {:error, %{changeset: changeset}}
        end

      _ ->
        # Ignore other events
        conn
        |> put_status(:ok)
        |> json(:ok)
    end
  end

  defp authenticate_api_key(conn, _options) do
    match = Matches.get_match!(conn.params["id"])

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
