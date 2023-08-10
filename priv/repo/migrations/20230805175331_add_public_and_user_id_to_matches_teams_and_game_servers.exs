defmodule Get5Api.Repo.Migrations.AddPublicAndUserIdToMatchesTeamsAndGameServers do
  use Ecto.Migration

  def change do
    alter table("matches") do
      add :public, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing)
    end

    alter table("game_servers") do
      add :public, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing)
    end

    alter table("teams") do
      add :public, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:matches, [:user_id])
    create index(:game_servers, [:user_id])
    create index(:teams, [:user_id])
  end
end
