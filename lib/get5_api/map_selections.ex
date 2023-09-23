defmodule Get5Api.MapSelections do
  @moduledoc """
  The MapSelections context.
  """

  import Ecto.Query, warn: false
  alias Get5Api.Repo

  alias Get5Api.MapSelections.MapSelection

  @doc """
  Returns the list of map_selections.

  ## Examples

      iex> list_map_selections()
      [%MapSelection{}, ...]

  """
  def list_map_selections do
    Repo.all(MapSelection)
  end

  @doc """
  Gets a single map_selection.

  Raises `Ecto.NoResultsError` if the Map selection does not exist.

  ## Examples

      iex> get_map_selection!(123)
      %MapSelection{}

      iex> get_map_selection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_map_selection!(id), do: Repo.get!(MapSelection, id)

  def get_map_selections_by_match(match_id) do
    from(ms in Get5Api.MapSelections.MapSelection,
      where: ms.match_id == ^match_id and ms.pick_or_ban == :pick,
      order_by: ms.id
    )
    |> Repo.all()
  end

  def get_picked_map(match_id, team_name, map_number) do
    Repo.one(MapSelection.picked_map(match_id, team_name, map_number))
  end

  @doc """
  Creates a map_selection.

  ## Examples

      iex> create_map_selection(%{field: value})
      {:ok, %MapSelection{}}

      iex> create_map_selection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_map_selection(attrs \\ %{}) do
    %MapSelection{}
    |> MapSelection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a map_selection.

  ## Examples

      iex> update_map_selection(map_selection, %{field: new_value})
      {:ok, %MapSelection{}}

      iex> update_map_selection(map_selection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_map_selection(%MapSelection{} = map_selection, attrs) do
    map_selection
    |> MapSelection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a map_selection.

  ## Examples

      iex> delete_map_selection(map_selection)
      {:ok, %MapSelection{}}

      iex> delete_map_selection(map_selection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_map_selection(%MapSelection{} = map_selection) do
    Repo.delete(map_selection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking map_selection changes.

  ## Examples

      iex> change_map_selection(map_selection)
      %Ecto.Changeset{data: %MapSelection{}}

  """
  def change_map_selection(%MapSelection{} = map_selection, attrs \\ %{}) do
    MapSelection.changeset(map_selection, attrs)
  end

  alias Get5Api.MapSelections.SideSelection

  @doc """
  Returns the list of side_selections.

  ## Examples

      iex> list_side_selections()
      [%SideSelection{}, ...]

  """
  def list_side_selections do
    Repo.all(SideSelection)
  end

  @doc """
  Gets a single side_selection.

  Raises `Ecto.NoResultsError` if the Side selection does not exist.

  ## Examples

      iex> get_side_selection!(123)
      %SideSelection{}

      iex> get_side_selection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_side_selection!(id), do: Repo.get!(SideSelection, id)

  @doc """
  Creates a side_selection.

  ## Examples

      iex> create_side_selection(%{field: value})
      {:ok, %SideSelection{}}

      iex> create_side_selection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_side_selection(attrs \\ %{}) do
    %SideSelection{}
    |> SideSelection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a side_selection.

  ## Examples

      iex> update_side_selection(side_selection, %{field: new_value})
      {:ok, %SideSelection{}}

      iex> update_side_selection(side_selection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_side_selection(%SideSelection{} = side_selection, attrs) do
    side_selection
    |> SideSelection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a side_selection.

  ## Examples

      iex> delete_side_selection(side_selection)
      {:ok, %SideSelection{}}

      iex> delete_side_selection(side_selection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_side_selection(%SideSelection{} = side_selection) do
    Repo.delete(side_selection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking side_selection changes.

  ## Examples

      iex> change_side_selection(side_selection)
      %Ecto.Changeset{data: %SideSelection{}}

  """
  def change_side_selection(%SideSelection{} = side_selection, attrs \\ %{}) do
    SideSelection.changeset(side_selection, attrs)
  end
end
