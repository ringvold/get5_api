defmodule Get5ApiWeb.TeamResolver do
  alias Get5Api.Teams

  def all_teams(_root, _args, _info) do
    teams = Teams.list_teams() |> Enum.map(&to_graphql/1)
    {:ok, teams}
  end

  defp to_graphql(%Teams.Team{id: id, name: name, players: players}) do
    %{id: id, name: name, players: Enum.map(players,
      fn {id, name} -> %{id: id, name: name} end)}
  end
end
