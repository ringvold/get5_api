defmodule Get5Api.Matches.Match do
  use Ecto.Schema
  import Ecto.Changeset
  alias Get5Api.Teams.Team
  alias Get5Api.GameServers.GameServer

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "matches" do
    field :api_key, :string
    field :end_time, :utc_datetime
    field :enforce_teams, :boolean, default: false
    field :max_maps, :integer
    field :min_player_ready, :integer
    field :series_type, :string
    field :spectator_ids, {:array, :string}
    field :start_time, :utc_datetime
    field :status, :string
    field :team1_score, :integer
    field :team2_score, :integer
    field :title, :string
    field :veto_first, :string
    field :veto_map_pool, {:array, :string}
    field :winner, :binary_id

    belongs_to :team1, Team
    belongs_to :team2, Team
    belongs_to :game_server, GameServer

    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [
      :title,
      :series_type,
      :veto_map_pool,
      :veto_first,
      :spectator_ids,
      :enforce_teams,
      :start_time,
      :end_time,
      :min_player_ready,
      :status,
      :max_maps,
      :team1_score,
      :team2_score
    ])
    |> validate_required([
      :title,
      :series_type,
      :veto_map_pool,
      :veto_first,
      :spectator_ids,
      :start_time,
      :end_time,
      :min_player_ready,
      :status,
      :max_maps
    ])
  end

  ## Series type
  # ('bo1-preset', 'Bo1 with preset map'),
  # ('bo1', 'Bo1 with map vetoes'),
  # ('bo2', 'Bo2 with map vetoes'),
  # ('bo3', 'Bo3 with map vetoes'),
  # ('bo5', 'Bo5 with map vetoes'),
  # ('bo7', 'Bo7 with map vetoes'),

  ## Statuses (code from original project)
  # def finalized(self):
  #     return self.cancelled or self.finished()
  # def pending(self):
  #     return self.start_time is None and not self.cancelled
  # def finished(self):
  #     return self.end_time is not None and not self.cancelled
  # def live(self):
  #     return self.start_time is not None and self.end_time is None and not self.cancelled

  ## Match validators
  # def different_teams_validator(form, field):
  #   if form.team1_id.data == form.team2_id.data:
  #       raise ValidationError('Teams cannot be equal')

  # def mappool_validator(form, field):
  #     if 'preset' in form.series_type.data and len(form.veto_mappool.data) != 1:
  #         raise ValidationError(
  #             'You must have exactly 1 map selected to do a bo1 with a preset map')

  #     max_maps = 1
  #     try:
  #         max_maps = int(form.series_type.data[2])
  #     except ValueError:
  #         max_maps = 1

  #     if len(form.veto_mappool.data) < max_maps:
  #         raise ValidationError(
  #             'You must have at least {} maps selected to do a Bo{}'.format(max_maps, max_maps))

  # def series_score_validator(form, field):
  #     team1 = form.team1_series_score.data if not None else 0
  #     team2 = form.team2_series_score.data if not None else 0
  #     if int(team1) < 0 or int(team2) < 0:
  #         raise ValidationError("You cannot have a negative series score.")
end
