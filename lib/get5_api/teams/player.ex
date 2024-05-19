defmodule Get5Api.Teams.Player do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :steam_id
    field :name
  end

  def changeset(player, attrs) do
    player
    |> cast(attrs, [:id, :steam_id, :name])
    |> validate_required([:steam_id])
  end
end
