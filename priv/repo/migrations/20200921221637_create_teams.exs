defmodule Get5Api.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      add :players, :map, default: "[]"

      timestamps()
    end
  end
end
