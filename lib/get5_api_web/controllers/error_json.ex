defmodule Get5ApiWeb.ErrorJSON do
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #

  def render(:invalid_payload, _assigns) do
    %{errors: %{detail: "Invalid payload"}}
  end

  def render("validation_error.json", %{conn: %{assigns: %{errors: _errors}}}) do
    %{errors: %{detail: "Invalid payload"}}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render(template, assigns) do
    dbg(template)
    dbg(assigns)
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
