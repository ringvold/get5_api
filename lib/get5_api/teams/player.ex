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


defimpl Inspect, for: Get5Api.Teams.Player do
  import Inspect.Algebra

  def inspect(player, opts) do
    concat(["Player( name:", to_doc(player, opts), ")"])
  end
end

defimpl String.Chars, for: Get5Api.Teams.Player do
  def to_string(player) do
    "#{player.name}: #{player.steam_id}"
  end
end
