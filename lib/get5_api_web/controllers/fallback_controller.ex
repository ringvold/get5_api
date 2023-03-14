defmodule Get5ApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use Get5ApiWeb, :controller


  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: Get5ApiWeb.ChangesetJSON)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :invalid_payload}) do
    conn
    |> put_status(:bad_request)
    |> put_view(html: Get5ApiWeb.ErrorHTML, json: Get5ApiWeb.ErrorJSON)
    |> render(:invalid_payload)
  end

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

  def call(conn, {:error, :internal_server_error}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(html: Get5ApiWeb.ErrorHTML, json: Get5ApiWeb.ErrorJSON)
    |> render(:"500")
  end

  def call(conn, {:error, :validation, errors}) do
    conn
    |> put_status(:bad_request)
    |> put_view(html: Get5ApiWeb.ErrorHTML, json: Get5ApiWeb.ErrorJSON)
    |> assign(:errors, errors)
    |> render(:validation_error)
  end

  def call(conn, data) do
    IO.inspect "Unkown fallback: #{data}"
    conn
    |> put_status(:internal_server_error)
    |> put_view(html: Get5ApiWeb.ErrorHTML, json: Get5ApiWeb.ErrorJSON)
    |> render(:"500")
  end


end
