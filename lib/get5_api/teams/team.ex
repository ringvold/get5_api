defmodule Get5Api.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset
  alias Get5Api.Matches.Match
  alias Get5Api.Teams.Player

  schema "teams" do
    field :name, :string
    embeds_many :players, Player, on_replace: :delete

    has_many :matches, Match
    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> cast_embed(:players)
    |> validate_required([:name])
    |> foreign_key_constraint(:matches_team1_id_fkey)
    |> foreign_key_constraint(:matches_team2_id_fkey)
  end
end
