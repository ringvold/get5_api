defmodule Get5ApiWeb.TeamResolver do
  alias Get5Api.Teams
  alias Get5Api.Teams.Player

  def all_teams(_root, _args, _info) do
    teams = Teams.list_teams()
    {:ok, teams}
  end

  def get_team(_root, args, _info) do
    case Teams.get_team(args.id) do
      nil ->
        {:error, "Team not found"}

      team ->
        {:ok, team}
    end
  end

  def create_team(_parent, %{name: name}, _context) do
    Teams.create_team(%{name: name})
  end

  def delete_team(_parent, %{id: id}, _context) do
    case Teams.get_team(id) do
      nil ->
        {:error, "Team not found"}

      team ->
        case Teams.delete_team(team) do
          {:ok, struct} ->
            {:ok, struct}

          {:error, changeset} ->
            IO.inspect(changeset)

            {:error, changeset}
        end
    end
  end

  def add_player(_parent, player, _context) do
    case Teams.get_team(player.team_id) do
      nil ->
        {:error, "Team not found"}

      team ->
        Teams.add_player(team, %Player{steam_id: player.steam_id, name: ""})
    end
  end

  def remove_player(_parent, player, _context) do
    case Teams.get_team(player.team_id) do
      nil ->
        {:error, "Team not found"}

      team ->
        Teams.remove_player(team, %Player{steam_id: player.steam_id, name: ""})
    end
  end
end
