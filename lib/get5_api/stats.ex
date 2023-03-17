defmodule Get5Api.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false
  alias Get5Api.Repo

  alias Get5Api.Stats.MatchStats

  @doc """
  Returns the list of match_stats.

  ## Examples

      iex> list_match_stats()
      [%MatchStats{}, ...]

  """
  def list_match_stats do
    Repo.all(MatchStats)
  end

  @doc """
  Gets a single match_stats.

  Raises `Ecto.NoResultsError` if the Match stats does not exist.

  ## Examples

      iex> get_match_stats!(123)
      %MatchStats{}

      iex> get_match_stats!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match_stats!(id), do: Repo.get!(MatchStats, id)

  @doc """
  Creates a match_stats.

  ## Examples

      iex> create_match_stats(%{field: value})
      {:ok, %MatchStats{}}

      iex> create_match_stats(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match_stats(attrs \\ %{}) do
    %MatchStats{}
    |> MatchStats.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a match_stats.

  ## Examples

      iex> update_match_stats(match_stats, %{field: new_value})
      {:ok, %MatchStats{}}

      iex> update_match_stats(match_stats, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match_stats(%MatchStats{} = match_stats, attrs) do
    match_stats
    |> MatchStats.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a match_stats.

  ## Examples

      iex> delete_match_stats(match_stats)
      {:ok, %MatchStats{}}

      iex> delete_match_stats(match_stats)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match_stats(%MatchStats{} = match_stats) do
    Repo.delete(match_stats)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match_stats changes.

  ## Examples

      iex> change_match_stats(match_stats)
      %Ecto.Changeset{data: %MatchStats{}}

  """
  def change_match_stats(%MatchStats{} = match_stats, attrs \\ %{}) do
    MatchStats.changeset(match_stats, attrs)
  end
end
