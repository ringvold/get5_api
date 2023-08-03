defmodule Get5Api.Repo.Migrations.CreateMapStats do
  use Ecto.Migration

  def change do
    create table(:map_stats) do
      add :map_number, :integer
      add :map_name, :string
      add :team1_score, :integer, default: 0
      add :team2_score, :integer, default: 0
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :match_id, references(:matches, on_delete: :nothing)
      add :winner_id, references(:teams, on_delete: :nothing)

      timestamps()
    end

    create index(:map_stats, [:match_id])
    create index(:map_stats, [:winner_id])
  end
end
