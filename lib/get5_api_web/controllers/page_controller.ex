defmodule Get5ApiWeb.PageController do
  use Get5ApiWeb, :controller

  def index(conn, _params) do
    conn
    |> put_layout(false)
    |> assign(:base_url, "")
    |> assign(:is_dev, is_dev?())
    |> render("index.html")
  end

  defp is_dev? do
    # Application.get_env(:get5_api, :env) in [:dev, :test]
    false
  end
end
