defmodule Get5Api.Teams.Player do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:steam_id, :string, autogenerate: false}
  embedded_schema do
    field :name
  end

  def changeset(player, attrs) do
    player
    |> cast(attrs, [:steam_id, :name])
    |> validate_required([:steam_id])
  end
end
