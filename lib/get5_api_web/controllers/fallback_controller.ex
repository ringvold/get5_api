defmodule Get5ApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use Get5ApiWeb, :controller

  def call(conn, {:error, :bad_request}) do
    conn
    |> put_status(:bad_request)
    |> put_view(html: Get5ApiWeb.ErrorHTML, json: Get5ApiWeb.ErrorJSON)
    |> render(:"400")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(html: Get5ApiWeb.ErrorHTML, json: Get5ApiWeb.ErrorJSON)
    |> render(:"401")
  end

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(:forbidden)
    |> put_view(html: Get5ApiWeb.ErrorHTML, json: Get5ApiWeb.ErrorJSON)
    |> render(:"403")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: Get5ApiWeb.ErrorHTML, json: Get5ApiWeb.ErrorJSON)
    |> render(:"404")
  end
end
