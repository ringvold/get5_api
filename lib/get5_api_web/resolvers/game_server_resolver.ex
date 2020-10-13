defmodule Get5ApiWeb.GameServerResolver do
  alias Get5Api.GameServers

  def all_game_servers(_root, _args, _info) do
    {:ok, GameServers.list_game_servers()}
  end

  def get_game_sever(_root, args, _info) do
    # TODO: Fix error handling on
    {:ok, GameServers.get_game_server!(args.id)}
  end

  def create_game_server(_parent, args, _context) do
    GameServers.create_game_server(args)
  end
end
