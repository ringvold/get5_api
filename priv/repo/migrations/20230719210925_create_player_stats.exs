defmodule Get5Api.Repo.Migrations.CreatePlayerStats do
  use Ecto.Migration

  def change do
    create table(:player_stats) do
      add :steam_id, :string, null: false
      add :kill, :integer, default: 0
      add :deaths, :integer, default: 0
      add :assists, :integer, default: 0
      add :flash_assists, :integer, default: 0
      add :team_kills, :integer, default: 0
      add :suicides, :integer, default: 0
      add :damage, :integer, default: 0
      add :utility_damage, :integer, default: 0
      add :enemies_flashed, :integer, default: 0
      add :friendlies_flashed, :integer, default: 0
      add :knife_kills, :integer, default: 0
      add :headshot_kills, :integer, default: 0
      add :rounds_played, :integer, default: 0
      add :bomb_defuses, :integer, default: 0
      add :bomb_plants, :integer, default: 0
      add :"1k", :integer, default: 0
      add :"2k", :integer, default: 0
      add :"3k", :integer, default: 0
      add :"4k", :integer, default: 0
      add :"5k", :integer, default: 0
      add :"1v1", :integer, default: 0
      add :"1v2", :integer, default: 0
      add :"1v3", :integer, default: 0
      add :"1v4", :integer, default: 0
      add :"1v5", :integer, default: 0
      add :first_kills_t, :integer, default: 0
      add :first_kills_ct, :integer, default: 0
      add :first_deaths_t, :integer, default: 0
      add :first_deaths_ct, :integer, default: 0
      add :trade_kills, :integer, default: 0
      add :kast, :integer, default: 0
      add :score, :integer, default: 0
      add :mvp, :integer, default: 0
      add :match_id, references(:matches, on_delete: :nothing)
      add :map_stats_id, references(:map_stats, on_delete: :nothing)
      add :team_id, references(:teams, on_delete: :nothing)

      timestamps()
    end

    create index(:player_stats, [:match_id])
    create index(:player_stats, [:map_stats_id])
    create index(:player_stats, [:team_id])
  end
end
