defmodule Get5Api.Repo.Migrations.CreateGameServers do
  use Ecto.Migration

  def change do
    create table(:game_servers) do
      add :name, :string
      add :host, :string, null: false
      add :port, :integer, default: 27015, null: false
      add :gotv_port, :integer, default: 27020, null: false
      add :encrypted_password, :string
      add :in_use, :boolean, default: false, null: false

      timestamps()
    end
  end
end
