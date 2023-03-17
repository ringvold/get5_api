defmodule Get5Api.Repo.Migrations.CreateMatchStats do
  use Ecto.Migration

  def change do
    create table(:match_stats) do
      add :map_number, :integer
      add :map_name, :string
      add :team1_score, :integer
      add :team2_score, :string
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :match_id, references(:matches, on_delete: :nothing)
      add :winner_id, references(:teams, on_delete: :nothing)

      timestamps()
    end

    create index(:match_stats, [:match_id])
    create index(:match_stats, [:match_id, :map_number])
    create index(:match_stats, [:winner_id])
  end
end
