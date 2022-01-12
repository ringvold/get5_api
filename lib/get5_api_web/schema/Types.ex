defmodule Get5ApiWeb.Schema.Types do
  use Absinthe.Schema.Notation

  object :game_server do
    field :id, non_null(:id)
    field :host, non_null(:string)
    field :in_use, non_null(:boolean)
    field :name, non_null(:string)
    field :port, non_null(:string)
  end

  object :match do
    field :id, non_null(:id)
    field :team1, non_null(:team)
    field :team2, non_null(:team)
    field :title, non_null(:string)
    field :game_server, non_null(:game_server)
    field :veto_map_pool, list_of(:string)
    field :series_type, non_null(:series_type)
    field :side_type, non_null(:side_type)
    field :spectator_ids, list_of(:string)
    field :start_time, non_null(:string)
    field :end_time, non_null(:string)
    field :enforce_teams, non_null(:boolean)
    field :max_maps, non_null(:integer)
    field :min_player_ready, non_null(:integer)
    field :status, :match_status
    field :team1_score, :integer
    field :team2_score, :integer
    field :veto_first, non_null(:match_team)
    field :api_key, non_null(:string)
    field :winner, :team
  end

  # Team

  object :team do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :players, list_of(:player)
  end

  object :player do
    field :steam_id, non_null(:string)
    field :name, :string
  end

  input_object :player_input do
    field :steam_id, non_null(:string)
    field :name, :string
  end

  enum :side_type do
    value(:standard)
    value(:never_knife)
    value(:always_knife)
  end

  enum :series_type do
    value(:bo1_preset)
    value(:bo1)
    value(:bo2)
    value(:bo3)
    value(:bo5)
    value(:bo7)
  end

  enum :match_status do
    value(:cancelled)
    value(:forfeit)
  end

  enum :match_team do
    value(:team1)
    value(:team2)
  end
end
