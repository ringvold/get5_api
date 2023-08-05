defmodule Get5Api.MapSelections.SideSelection do
  use Ecto.Schema
  import Ecto.Changeset

  alias Get5Api.MapSelections.MapSelection

  schema "side_selections" do
    field :map_name, :string
    field :side,  Ecto.Enum, values: [:t, :ct]
    field :team_name, :string

    belongs_to(:match, Matche)
    belongs_to(:map_selection, MapSelection)


    timestamps()
  end

  @doc false
  def changeset(side_selection, attrs) do
    side_selection
    |> cast(attrs, [:match_id, :map_selection_id, :team_name, :map_name, :side])
    |> cast_assoc(:match)
    |> cast_assoc(:map_selection)
    |> validate_required([:match_id, :map_selection_id, :team_name, :map_name, :side])
  end
end
