defmodule Get5Api.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :players, :map

      timestamps()
    end
  end
end
