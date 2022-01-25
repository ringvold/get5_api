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
        {:ok, match}
    end
  end

  def create_match(_parent, args, _context) do
    Matches.create_match(args)
  end

end
