defmodule Get5Api.Stats.PlayerStats do
  use Ecto.Schema
  import Ecto.Changeset

  alias Get5Api.Teams.Team
  alias Get5Api.Matches.Match
  alias Get5Api.Stats.MapStats

  schema "player_stats" do
    field :steam_id, :string
    field :name, :string
    field :assists, :integer
    field :bomb_defuses, :integer
    field :bomb_plants, :integer
    field :damage, :integer
    field :deaths, :integer
    field :enemies_flashed, :integer
    field :flash_assists, :integer
    field :friendlies_flashed, :integer
    field :headshot_kills, :integer
    field :mvp, :integer
    field :kast, :integer
    field :kills, :integer
    field :knife_kills, :integer
    field :rounds_played, :integer
    field :team_kills, :integer
    field :trade_kills, :integer
    field :score, :integer
    field :suicides, :integer
    field :utility_damage, :integer
    field :"1k", :integer
    field :"2k", :integer
    field :"3k", :integer
    field :"4k", :integer
    field :"5k", :integer
    field :"1v1", :integer
    field :"1v2", :integer
    field :"1v3", :integer
    field :"1v4", :integer
    field :"1v5", :integer
    field :first_kills_t, :integer
    field :first_kills_ct, :integer
    field :first_deaths_t, :integer
    field :first_deaths_ct, :integer

    belongs_to(:match, Match)
    belongs_to(:map_stats, MapStats)
    belongs_to(:team, Team)

    timestamps()
  end

  @doc false
  def changeset(player_stats, attrs) do
    player_stats
    |> cast(attrs, [
      :steam_id,
      :kill,
      :deaths,
      :assists,
      :flash_assists,
      :team_kills,
      :suicides,
      :damage,
      :utility_damage,
      :enemies_flashed,
      :friendlies_flashed,
      :knife_kills,
      :headshot_kills,
      :rounds_played,
      :bomb_defuses,
      :bomb_plants,
      :"1k",
      :"2k",
      :"3k",
      :"4k",
      :"5k",
      :"1v1",
      :"1v2",
      :"1v3",
      :"1v4",
      :"1v5",
      :first_kills_t,
      :first_kills_ct,
      :first_deaths_t,
      :first_deaths_ct,
      :trade_kills,
      :kast,
      :score,
      :mvp
    ])
    |> cast_assoc(:match)
    |> cast_assoc(:map_stats)
    |> cast_assoc(:team)
    |> validate_required([
      :team_id,
      :match_id,
      :map_id
    ])
    |> validate_required([:steam_id])
  end
end
