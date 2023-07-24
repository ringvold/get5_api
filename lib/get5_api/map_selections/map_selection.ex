defmodule Get5Api.MapSelections.MapSelection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "map_selections" do
    field :map_name, :string
    field :team_name, :string
    field :pick_or_ban, Ecto.Enum, values: [:pick, :ban]

    belongs_to(:match, Match)

    timestamps()
  end

  @doc false
  def changeset(map_selection, attrs) do
    map_selection
    |> cast(attrs, [:match_id, :team_name, :map_name, :pick_or_ban])
    |> cast_assoc(:match)
    |> validate_required([:team_name, :map_name, :pick_or_ban])
  end
end
