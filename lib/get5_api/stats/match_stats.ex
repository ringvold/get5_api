defmodule Get5Api.Stats.MatchStats do
  use Ecto.Schema
  import Ecto.Changeset

  schema "match_stats" do
    field :end_time, :utc_datetime
    field :map_name, :string
    field :map_number, :integer
    field :start_time, :utc_datetime
    field :team1_score, :integer
    field :team2_score, :string
    field :match_id, :binary_id
    field :winner_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(match_stats, attrs) do
    match_stats
    |> cast(attrs, [:map_number, :map_name, :team1_score, :team2_score, :start_time, :end_time])
    |> validate_required([:map_number, :map_name, :team1_score, :team2_score, :start_time, :end_time])
  end
end
