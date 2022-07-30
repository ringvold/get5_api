defmodule Get5Api.Repo.Migrations.RenameRconPasswordInGameServers do
  use Ecto.Migration

  def change do
    rename(table(:game_servers), :rcon_password, to: :hashed_rcon_password)
  end
end
