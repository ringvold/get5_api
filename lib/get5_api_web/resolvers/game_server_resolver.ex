defmodule Get5ApiWeb.GameServerResolver do
  alias Get5Api.GameServers

  def all_game_servers(_root, _args, _info) do
    {:ok, GameServers.list_game_servers(nil)}
  end

  def get_game_sever(_root, args, _info) do
    # TODO: Fix error handling on
    {:ok, GameServers.get_game_server!(args.id)}
  end

  def create_game_server(_parent, args, _context) do
    GameServers.create_game_server(args)
  end

  def delete_game_server(_parent, %{id: id}, _context) do
    case GameServers.get_game_server(id) do
      nil ->
        {:error, "Team not found"}

      _game_server ->
        # TODO: Pass actual user from context for authorization
        # For now, check if server belongs to user before deleting
        case GameServers.get_game_server(id) do
          %{user_id: user_id} when not is_nil(user_id) ->
            # Need user struct to delete - this requires auth context
            {:error, "Authentication required to delete game server"}

          _ ->
            {:error, "Game server not found or invalid"}
        end
    end
  end
end
