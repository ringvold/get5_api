defmodule Get5ApiWeb.MatchResolver do
  alias Get5Api.Matches
  alias Get5Api.Teams

  def all_matches(_root, _args, _info) do
    matches = Matches.list_matches()
    {:ok, matches}
  end

  def get_match(_root, args, _info) do
    case Matches.get_match(args.id) do
      nil ->
        {:error, "Match not found"}

      match ->
        match = %Matches.Match{match | team1: to_graphql(match.team1)}
        match = %Matches.Match{match | team2: to_graphql(match.team2)}

        {:ok, match}
    end
  end

  def create_match(_parent, args, _context) do
    Matches.create_match(args)
  end

  #
  # Maybe DRY up this later. Is also in teams_resolver.ex
  #
  defp to_graphql({:ok, team = %Teams.Team{}}) do
    to_graphql(team)
  end

  defp to_graphql(%Teams.Team{id: id, name: name, players: nil}) do
    %{
      id: id,
      name: name,
      players: []
    }
  end

  defp to_graphql(%Teams.Team{id: id, name: name, players: players}) do
    %{
      id: id,
      name: name,
      players:
        Enum.map(
          players,
          &map_to_player/1
        )
    }
  end

  defp map_to_player({id}), do: %{steam_id: id}

  defp map_to_player({id, name}), do: %{steam_id: id, name: name}
end
