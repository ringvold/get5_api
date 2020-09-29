defmodule Get5Api.Repo.Migrations.AddGameServerIdToMatches do
  use Ecto.Migration

  def change do
    alter table("matches") do
      add :game_server_id, references(:game_servers, on_delete: :nothing, type: :binary_id)
    end
  end
end
