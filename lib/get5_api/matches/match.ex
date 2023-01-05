defmodule Get5Api.Matches.Match do
  use Ecto.Schema
  import Ecto.Changeset
  alias Get5Api.Teams.Team
  alias Get5Api.GameServers.GameServer

  @type series_type() :: :bo1_preset | :bo1 | :bo2 | :bo3 | :bo5 | :bo7

  # Side type is defined by Get5 in match schema https://github.com/splewis/get5#match-schema
  @type side_type() :: :standard | :always_knife | :never_knife

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "matches" do
    field(:api_key, :string)
    field(:end_time, :utc_datetime)
    field(:enforce_teams, :boolean, default: false)
    field(:max_maps, :integer)
    field(:min_player_ready, :integer)

    field(:side_type, Ecto.Enum,
      values: [:standard, :always_knife, :never_knife],
      default: :standard
    )

    field(:series_type, Ecto.Enum,
      values: [:bo1_preset, :bo1, :bo2, :bo3, :bo5, :bo7],
      default: :bo1_preset
    )

    field(:spectator_ids, {:array, :string})
    field(:start_time, :utc_datetime)
    field(:status, :string)
    field(:team1_score, :integer)
    field(:team2_score, :integer)
    field(:title, :string)
    field(:veto_first, :string)
    field(:veto_map_pool, {:array, :string})
    field(:winner, :binary_id)

    belongs_to(:team1, Team)
    belongs_to(:team2, Team)
    belongs_to(:game_server, GameServer)

    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [
      :team1_id,
      :team2_id,
      :game_server_id,
      :veto_map_pool,
      :api_key,
      :title,
      :series_type,
      :veto_first,
      :spectator_ids,
      :enforce_teams,
      :min_player_ready,
      :status,
      :team1_score,
      :team2_score
    ])
    |> cast_assoc(:team1)
    |> cast_assoc(:team2)
    |> cast_assoc(:game_server)
    |> validate_required([
      :team1_id,
      :team2_id,
      :game_server_id
    ])
    |> validate_map_pool()
    |> validate_different_teams()
    |> ensure_api_key()
    # Set manually for now
    |> put_change(:start_time, DateTime.utc_now() |> DateTime.truncate(:second))
  end

  @spec ensure_api_key(Ecto.Changeset.t(), any) :: Ecto.Changeset.t()
  def ensure_api_key(changeset, _options \\ []) do
    if get_change(changeset, :api_key) do
      changeset
    else
      changeset
      |> put_change(:api_key, Ecto.UUID.generate())
    end
  end

  @spec validate_different_teams(Ecto.Changeset.t(), any) :: Ecto.Changeset.t()
  def validate_different_teams(changeset, options \\ []) do
    team1 = get_field(changeset, :team1_id)
    team2 = get_field(changeset, :team2_id)

    if team1 != nil &&
         team2 != nil &&
         team1 == team2 do
      add_error(changeset, :team1_id, options[:message] || "Team1 and team2 cannot be the same")
    else
      changeset
    end
  end

  @spec validate_map_pool(Ecto.Changeset.t(), Keyword.t()) :: Ecto.Changeset.t()
  def validate_map_pool(changeset, options \\ []) do
    maps = get_field(changeset, :veto_map_pool, [])
    maps = if maps == nil, do: [], else: maps

    with :bo1_preset_valid <- is_bo1_preset_with_multiple_maps(changeset, maps),
         :minimum_maps_valid <- selected_maps_count_matches_series_type(changeset, maps) do
      changeset
    else
      :bo1_preset_error ->
        add_error(
          changeset,
          :veto_map_pool,
          options[:bo1_preset_message] ||
            "must have exactly 1 map selected to do a bo1_preset"
        )

      {:minimum_maps_error, max_maps} ->
        add_error(
          changeset,
          :veto_map_pool,
          options[:max_maps_message] ||
            "must have at least #{max_maps} maps selected to do a Bo#{max_maps}"
        )
    end
  end

  def is_bo1_preset_with_multiple_maps(changeset, maps) do
    series_type = get_field(changeset, :series_type)

    if(series_type == :bo1_preset and (maps == ["all"] or length(maps) != 1)) do
      :bo1_preset_error
    else
      :bo1_preset_valid
    end
  end

  def selected_maps_count_matches_series_type(_changeset, ["all"]) do
    :minimum_maps_valid
  end

  def selected_maps_count_matches_series_type(changeset, maps) do
    series_type = get_field(changeset, :series_type)
    max_maps = series_type_to_max_maps(series_type)
    maps_size = length(List.delete(maps, "all"))

    if series_type != :bo1_preset and (maps_size < max_maps and maps_size > 0) do
      {:minimum_maps_error, max_maps}
    else
      :minimum_maps_valid
    end
  end

  @spec series_type_to_max_maps(series_type()) :: integer()
  def series_type_to_max_maps(series_type) do
    case series_type do
      :bo1_preset -> 1
      :bo1 -> 1
      :bo2 -> 2
      :bo3 -> 3
      :bo5 -> 5
      :bo7 -> 7
      _ -> 1
    end
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
