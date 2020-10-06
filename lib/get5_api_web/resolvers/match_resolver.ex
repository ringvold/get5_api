defmodule Get5ApiWeb.MatchResolver do
  alias Get5Api.Matches

  def all_matches(_root, _args, _info) do
    matches = Matches.list_matches()
    {:ok, matches}
  end

  def create_match(_parent, args, _context) do
    Matches.create_match(args)
  end
end
