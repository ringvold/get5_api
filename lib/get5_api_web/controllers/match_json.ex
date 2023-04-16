defmodule Get5ApiWeb.MatchJSON do

  @doc """
  Renders match config for starting match in Get5
  """
  def match_config(%{match_config: match_config}) do
    match_config
  end

  def series_start(%{validation_errors: errors}) do
    %{errors: errors}
  end

end
