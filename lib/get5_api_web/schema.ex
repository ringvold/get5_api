defmodule Get5ApiWeb.Schema do
  use Absinthe.Schema

  alias Get5ApiWeb.TeamResolver
  alias Get5ApiWeb.GameServerResolver
  alias Get5ApiWeb.MatchResolver

  import AbsintheErrorPayload.Payload
  import_types(AbsintheErrorPayload.ValidationMessageTypes)
  import_types(Get5ApiWeb.Schema.Types)

  query do
    #
    #  Team
    #

    @desc "Get all teams"
    field :all_teams, non_null(list_of(non_null(:team))) do
      resolve(&TeamResolver.all_teams/3)
    end

    @desc "Get a team"
    field :team, non_null(:team) do
      arg(:id, non_null(:id))
      resolve(&TeamResolver.get_team/3)
    end

    #
    # Game Server
    #

    @desc "Get all game server"
    field :all_game_servers, non_null(list_of(non_null(:game_server))) do
      resolve(&GameServerResolver.all_game_servers/3)
    end

    @desc "Get a game server"
    field :game_server, non_null(:game_server) do
      arg(:id, non_null(:id))
      resolve(&GameServerResolver.get_game_sever/3)
    end

    #
    # Match
    #

    @desc "Get all matches"
    field :all_matches, non_null(list_of(non_null(:match))) do
      resolve(&MatchResolver.all_matches/3)
    end

    @desc "Get match"
    field :match, non_null(:match) do
      arg(:id, non_null(:id))
      resolve(&MatchResolver.get_match/3)
    end
  end

  mutation do
    #
    #  Team Mutations
    #

    @desc "Create team"
    field :create_team, type: :team do
      arg(:name, non_null(:string))
      arg(:players, list_of(:player_input))
      resolve(&TeamResolver.create_team/3)
    end

    @desc "Delete team"
    field :delete_team, type: :team do
      arg(:id, non_null(:string))
      resolve(&TeamResolver.delete_team/3)
    end

    @desc "Add player to a team"
    field :add_player, type: non_null(list_of(non_null(:player))) do
      arg(:team_id, non_null(:string))
      arg(:steam_id, non_null(:string))
      arg(:name, :string)
      resolve(&TeamResolver.add_player/3)
    end

    @desc "Remove player from a team"
    field :remove_player, type: non_null(list_of(non_null(:player))) do
      arg(:team_id, non_null(:string))
      arg(:steam_id, non_null(:string))
      resolve(&TeamResolver.remove_player/3)
    end

    #
    # Game Server Mutations
    #

    @desc "Create a game server"
    field :create_game_server, type: :game_server do
      arg(:name, non_null(:string))
      arg(:host, non_null(:string))
      arg(:port, non_null(:string))
      arg(:rcon_password, non_null(:string))

      resolve(&GameServerResolver.create_game_server/3)
    end

    @desc "Delete game server"
    field :delete_game_server, type: :game_server do
      arg(:id, non_null(:string))
      resolve(&GameServerResolver.delete_game_server/3)
    end

    #
    # Match Mutations
    #

    @desc "Create a match"
    field :create_match, type: :match_payload do
      arg(:team1_id, non_null(:id))
      arg(:team2_id, non_null(:id))
      arg(:game_server_id, non_null(:id))
      arg(:map_list, non_null(list_of(non_null(:string))))
      arg(:series_type, :series_type)
      arg(:side_type, :side_type)
      arg(:spectator_ids, list_of(:string))
      arg(:enforce_teams, :boolean)
      arg(:veto_first, :match_team)

      resolve(&MatchResolver.create_match/3)
      middleware(&build_payload/2)
    end
  end

  #
  # Payloads
  #

  payload_object(:match_payload, :match)
end
