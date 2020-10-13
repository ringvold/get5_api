defmodule Get5ApiWeb.Schema do
  use Absinthe.Schema

  alias Get5ApiWeb.TeamResolver
  alias Get5ApiWeb.GameServerResolver
  alias Get5ApiWeb.MatchResolver

  import_types(Get5ApiWeb.Schema.Types)

  query do
    @desc "Get all teams"
    field :all_teams, non_null(list_of(non_null(:team))) do
      resolve(&TeamResolver.all_teams/3)
    end

    @desc "Get all game server"
    field :all_game_servers, non_null(list_of(non_null(:game_server))) do
      resolve(&GameServerResolver.all_game_servers/3)
    end

    @desc "Get a game server"
    field :game_server, non_null(:game_server) do
      arg(:id, non_null(:id))
      resolve(&GameServerResolver.get_game_sever/3)
    end

    @desc "Get a game server"
    field :team, non_null(:team) do
      arg(:id, non_null(:id))
      resolve(&TeamResolver.get_team/3)
    end

    @desc "Get all matches"
    field :all_matches, non_null(list_of(non_null(:match))) do
      resolve(&MatchResolver.all_matches/3)
    end
  end

  mutation do
    @desc "Create a game server"
    field :create_game_server, type: :game_server do
      arg(:name, non_null(:string))
      arg(:host, non_null(:string))
      arg(:port, non_null(:string))
      arg(:rcon_password, non_null(:string))

      resolve(&GameServerResolver.create_game_server/3)
    end

    @desc "Create a team"
    field :create_team, type: :team do
      arg(:name, non_null(:string))
      arg(:players, non_null(list_of(:player_input)))

      resolve(&TeamResolver.create_team/3)
    end

    @desc "Create a match"
    field :create_match, type: :match do
      arg(:team1, non_null(:string))
      arg(:team2, non_null(:string))
      arg(:title, :string)
      arg(:game_server, non_null(:string))
      arg(:veto_map_pool, non_null(list_of(:string)))
      arg(:series_type, non_null(:string))
      arg(:spectator_ids, list_of(:string))
      arg(:enforce_teams, :boolean)
      arg(:veto_first, :string)

      resolve(&MatchResolver.create_match/3)
    end
  end
end
