defmodule Get5ApiWeb.AuthController do
  use Get5ApiWeb, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias UeberauthExample.UserFromAuth

  def request(conn, _params) do
    IO.puts("REQUEST FUNCTION MED CALLBACK_URL TING!")

    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    IO.inspect(fails)
    IO.puts("LOL DET KOM HIT ISTEDET!!!!!")

    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    IO.puts("TEST LOL DET KOM HIT YAY!")
    IO.inspect(auth)
    conn
    # case UserFromAuth.find_or_create(auth) do
    #   {:ok, user} ->
    #     conn
    #     |> put_flash(:info, "Successfully authenticated.")
    #     |> put_session(:current_user, user)
    #     |> configure_session(renew: true)
    #     |> redirect(to: "/")

    #   {:error, reason} ->
    #     conn
    #     |> put_flash(:error, reason)
    #     |> redirect(to: "/")
    # end
  end
end
