defmodule Get5ApiWeb.PageController do
  use Get5ApiWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def app(conn, _params) do
    conn
    |> assign(:base_url, "")
    |> assign(:is_dev, is_dev?())
    |> render("app.html")
  end

  defp is_dev? do
    # Application.get_env(:get5_api, :env) in [:dev, :test]
    false
  end
end
