defmodule Get5Api.MapSelections.MapSelection do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

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

  def picked_map(match_id, team_name, map_name) do
    from(ms in Get5Api.MapSelections.MapSelection,
      where:
        ms.match_id == ^match_id and ms.pick_or_ban == :pick and ms.map_name == ^map_name and
          ms.team_name == ^team_name
    )
  end
end
