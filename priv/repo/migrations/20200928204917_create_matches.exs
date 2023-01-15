defmodule Get5Api.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :matchid, :serial
      add :title, :string
      add :series_type, :string
      add :side_type, :string
      add :veto_map_pool, {:array, :string}
      add :veto_first, :string
      add :spectator_ids, {:array, :string}
      add :enforce_teams, :boolean, default: true, null: false
      add :api_key, :string
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :min_player_ready, :integer, default: 5
      add :status, :string
      add :max_maps, :integer
      add :team1_score, :integer, default: 0
      add :team2_score, :integer, default: 0
      add :team1_id, references(:teams, on_delete: :nothing, type: :binary_id)
      add :team2_id, references(:teams, on_delete: :nothing, type: :binary_id)
      add :winner, references(:teams, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:matches, [:team1_id])
    create index(:matches, [:team2_id])
    create index(:matches, [:winner])
  end
end
