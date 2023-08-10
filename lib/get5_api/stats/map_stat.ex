defmodule Get5Api.Stats.MapStats do
  use Ecto.Schema
  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset

  alias Get5Api.Matches.Match
  alias Get5Api.Teams.Team

  schema "map_stats" do
    field :map_name, :string
    field :map_number, :integer
    field :team1_score, :integer
    field :team2_score, :integer
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    belongs_to(:match, Match)
    belongs_to(:winner, Team)

    timestamps()
  end

  @doc false
  def changeset(map_stats, attrs) do
    map_stats
    |> cast(attrs, [
      :map_number,
      :map_name,
      :team1_score,
      :team2_score,
      :start_time,
      :end_time,
      :match_id,
      :winner_id
    ])
    |> cast_assoc(:winner)
    |> cast_assoc(:match)
    |> validate_required([
      :match_id,
      :winner_id
    ])
  end

  def by_match_and_map_number(match_id, map_number) do
    from(ms in Get5Api.Stats.MapStats,
      where: ms.match_id == ^match_id and ms.map_number == ^map_number
    )
  end
end
