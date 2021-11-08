defmodule Get5ApiWeb.TeamResolver do
  alias Get5Api.Teams

  def all_teams(_root, _args, _info) do
    teams = Teams.list_teams() |> Enum.map(&to_graphql/1)
    {:ok, teams}
  end

  def get_team(_root, args, _info) do
    case Teams.get_team(args.id) do
      nil ->
        {:error, "Team not found"}

      team ->
        {:ok, to_graphql(team)}
    end
  end

  def create_team(_parent, %{name: name}, _context) do
    case Teams.create_team(%{name: name}) do
      {:ok, team} ->
        {:ok, to_graphql(team)}

      err ->
        err
    end
  end

  def add_player(_parent, player, _context) do
    case Teams.get_team(player.team_id) do
      nil ->
        {:error, "Team not found"}

      team ->
        players = input_player_to_map(player, team.players)

        IO.inspect(players)

        case Teams.update_team(team, %{players: players}) do
          {:ok, updated_team} ->
            IO.inspect(updated_team)

            IO.puts("GOT HERE!!!!!!!!!!!")
            {:ok, updated_team.players}

          {:error, changeset} ->
            {:error, "Could not add player to team"}
        end
    end
  end

  defp input_player_to_map(%{steam_id: id, team_id: team_id}, acc) do
    Map.put(acc, id, nil)
  end

  defp input_player_to_map(%{steam_id: id, team_id: team_id, name: name}, acc) do
    Map.put(acc, id, name)
  end

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
