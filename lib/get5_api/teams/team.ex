defmodule Get5Api.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset
  alias Get5Api.Matches.Match

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "teams" do
    field :name, :string
    field :players, :map

    has_many :matches, Match
    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :players])
    |> validate_required([:name])
  end
end
