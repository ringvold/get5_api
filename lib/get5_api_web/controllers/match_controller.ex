defmodule Get5ApiWeb.MatchController do
  use Get5ApiWeb, :controller

  alias Get5Api.Matches
  alias Get5Api.Matches.MatchConfigGenerator

  action_fallback Get5ApiWeb.FallbackController

  def match_config(conn, %{"id" => id}) do
    match = Matches.get_match!(id)
    match_config = MatchConfigGenerator.generate_config(match)
    render(conn, :match_config, match_config: match_config)
  end

  defp authenicate_request(conn, match) do
    ""
  end
end
