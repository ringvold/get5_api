defmodule Get5Api.Stats.RoundStat do
  use Ecto.Schema
  import Ecto.Changeset

  alias Get5Api.Matches.Match
  alias Get5Api.Stats.MapStats

  schema "round_stats" do
    field :round_number, :integer
    field :round_time, :integer
    field :reason, :integer
    field :team1_score, :integer
    field :team2_score, :integer
    field :winner_side, :string
    field :winner_team, :string

    belongs_to :match, Match
    belongs_to :map_stats, MapStats

    timestamps()
  end

  @doc false
  def changeset(round_stat, attrs) do
    round_stat
    |> cast(attrs, [
      :round_number,
      :round_time,
      :reason,
      :team1_score,
      :team2_score,
      :winner_side,
      :winner_team,
      :match_id,
      :map_stats_id
    ])
    |> validate_required([
      :round_number,
      :match_id
    ])
  end
end
