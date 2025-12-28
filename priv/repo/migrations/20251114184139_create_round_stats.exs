defmodule Get5Api.Repo.Migrations.CreateRoundStats do
  use Ecto.Migration

  def change do
    create table(:round_stats) do
      add :round_number, :integer, null: false
      add :round_time, :integer
      add :reason, :integer
      add :team1_score, :integer, default: 0
      add :team2_score, :integer, default: 0
      add :winner_side, :string
      add :winner_team, :string
      add :match_id, references(:matches, on_delete: :delete_all), null: false
      add :map_stats_id, references(:map_stats, on_delete: :delete_all)

      timestamps()
    end

    create index(:round_stats, [:match_id])
    create index(:round_stats, [:map_stats_id])
    create index(:round_stats, [:match_id, :round_number])
  end
end
