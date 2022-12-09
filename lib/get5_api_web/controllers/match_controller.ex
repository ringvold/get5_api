defmodule Get5ApiWeb.MatchController do
  use Get5ApiWeb, :controller

  alias Get5Api.Matches
  alias Get5Api.Matches.MatchConfigGenerator

  action_fallback Get5ApiWeb.FallbackController

  def match_config(conn, %{"id" => id}) do
    match = Matches.get_match!(id)

    case get_req_header(conn, "authorization") do
      [] ->
        {:error, :bad_request}

      [header] ->
        api_key = String.trim_leading(header, "Bearer ")
        if api_key != match.api_key do
          {:error, :unauthorized}
        else
          match_config = MatchConfigGenerator.generate_config(match)
          render(conn, :match_config, match_config: match_config)
        end

      _ ->
        {:error, :bad_request}

    end
  end
end
