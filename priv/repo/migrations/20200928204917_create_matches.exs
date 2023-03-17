defmodule Get5Api.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :title, :string
      add :series_type, :string
      add :side_type, :string
      add :map_list, {:array, :string}
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
      add :game_server_id, references(:game_servers, on_delete: :nothing)
      add :team1_id, references(:teams, on_delete: :nothing)
      add :team2_id, references(:teams, on_delete: :nothing)
      add :winner_id, references(:teams, on_delete: :nothing)
      add :plugin_version, :string, default: :unknown, null: false

      timestamps()
    end

    create index(:matches, [:team1_id])
    create index(:matches, [:team2_id])
    create index(:matches, [:winner_id])
  end
end
