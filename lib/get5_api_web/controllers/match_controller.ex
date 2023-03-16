defmodule Get5ApiWeb.MatchController do
  use Get5ApiWeb, :controller

  alias Get5Api.Matches
  alias Get5Api.Matches.MatchConfigGenerator
  import Jason.Helpers
  plug :authenticate_api_key

  action_fallback Get5ApiWeb.FallbackController

  def match_config(conn, _params) do
    match = conn.assigns.match

    match_config = MatchConfigGenerator.generate_config(match)
    render(conn, :match_config, match_config: match_config)
  end

  @series_start_params %{
    match_id: [type: :integer, required: true],
    map_number: [type: :string, required: true],
    map_name: [type: :string, required: true],
    version_number: [type: :string, required: true]
  }
  def series_start(conn, params) do
    with {:ok, _valid_params} <- Tarams.cast(params, @series_start_params) do
      case Matches.update_match(conn.assigns.match, %{start_time: DateTime.utc_now()}) do
        {:ok, _match} ->
          conn
            |> put_status(:ok)
        {:error, changeset } ->
          {:error, %{changeset: changeset}}
      end

    else
      {:error, errors} ->
        {:error, :validation, errors}
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
