defmodule Get5ApiWeb.GameServerResolver do
  alias Get5Api.GameServers

  def all_game_servers(_root, _args, _info) do
    {:ok, GameServers.list_game_servers()}
  end

end
