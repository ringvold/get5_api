defmodule Get5Api.Repo.Migrations.CreateSideSelections do
  use Ecto.Migration

  def change do
    create table(:side_selections) do
      add :team_name, :string
      add :map, :string
      add :side, :string
      add :match_id, references(:matches, on_delete: :nothing)
      add :map_selection_id, references(:map_selections, on_delete: :nothing)

      timestamps()
    end

    create index(:side_selections, [:match_id])
    create index(:side_selections, [:map_selection_id])
  end
end
