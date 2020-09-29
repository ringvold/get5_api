defmodule Get5Api.Matches.Match do
  use Ecto.Schema
  import Ecto.Changeset
  alias Get5Api.Teams.Team
  alias Get5Api.GameServers.GameServer

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "matches" do
    field :api_key, :string
    field :end_time, :utc_datetime
    field :enforce_teams, :boolean, default: false
    field :max_maps, :integer
    field :min_player_ready, :integer
    field :series_type, :string
    field :side_type, :string
    field :spectator_ids, {:array, :string}
    field :start_time, :utc_datetime
    field :status, :string
    field :team1_score, :integer
    field :team2_score, :integer
    field :title, :string
    field :veto_first, :string
    field :veto_map_pool, {:array, :string}
    field :winner, :binary_id

    belongs_to :team1, Team
    belongs_to :team2, Team
    belongs_to :game_server, GameServer

    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:title, :series_type, :veto_map_pool, :veto_first, :spectator_ids, :enforce_teams, :start_time, :end_time, :min_player_ready, :status, :max_maps, :team1_score, :team2_score])
    |> validate_required([:title, :series_type, :veto_map_pool, :veto_first, :spectator_ids, :start_time, :end_time, :min_player_ready, :status, :max_maps, :team1_score, :team2_score])
  end
end
