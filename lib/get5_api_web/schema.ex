defmodule Get5ApiWeb.Schema do
  use Absinthe.Schema

  alias Get5ApiWeb.TeamResolver
  alias Get5ApiWeb.GameServerResolver

  object :team do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :players, list_of(:player)
  end

  object :player do
    field :id, non_null(:string)
    field :name, non_null(:string)
  end

  object :game_server do
    field :host, non_null(:integer)
    field :in_use, non_null(:boolean)
    field :name, non_null(:string)
    field :port, non_null(:string)
  end

  query do
    @desc "Get all teams"
    field :all_teams, non_null(list_of(non_null(:team))) do
      resolve(&TeamResolver.all_teams/3)
    end

    @desc "Get all game server"
    field :all_game_servers, non_null(list_of(non_null(:team))) do
      resolve(&GameServerResolver.all_game_servers/3)
    end
  end
end
