defmodule Get5ApiWeb.ChangesetJSON do
  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `Get5ApiWeb.CoreCompponents.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &Get5ApiWeb.CoreComponents.translate_error/1)
  end

  @doc """
  Renders changeset errors.
  """
  def error(%{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: translate_errors(changeset)}
  end
end
