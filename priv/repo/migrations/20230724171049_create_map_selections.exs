defmodule Get5Api.Repo.Migrations.CreateMapSelections do
  use Ecto.Migration

  def change do
    create table(:map_selections) do
      add :team_name, :string
      add :map_name, :string
      add :pick_or_ban, :string
      add :match_id, references(:matches, on_delete: :nothing)

      timestamps()
    end

    create index(:map_selections, [:match_id])
  end
end
