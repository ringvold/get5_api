defmodule Get5Api.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset
  alias Get5Api.Matches.Match
  alias Get5Api.Teams.Player
  alias Get5Api.Accounts.User

  schema "teams" do
    field :name, :string
    field :public, :boolean, default: false

    embeds_many :players, Player, on_replace: :delete

    # Matches have team1_id and team2_id foreign keys, not a generic team_id
    # So we need separate associations for each
    has_many :team1_matches, Match, foreign_key: :team1_id
    has_many :team2_matches, Match, foreign_key: :team2_id
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :user_id, :public])
    |> cast_embed(:players)
    |> cast_assoc(:user)
    |> validate_required([:name])
    |> foreign_key_constraint(:matches_team1_id_fkey)
    |> foreign_key_constraint(:matches_team2_id_fkey)
  end
end
