defmodule Get5ApiWeb.GameServerLive.Show do
  use Get5ApiWeb, :live_view

  alias Get5Api.GameServers
  alias Get5Api.Encryption

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:game_server, GameServers.get_game_server!(id))
     |> assign(:show_password, false)
     |> assign(:rcon_password, "")}
  end

  def handle_event("show_password", _params, socket) do
    if socket.assigns.show_password do
      {:noreply,
       socket
       |> assign(:show_password, false)}
    else
      {:noreply,
       socket
       |> assign(:show_password, true)
       |> assign(
         :rcon_password,
         Encryption.decrypt(socket.assigns.game_server.hashed_rcon_password)
       )}
    end
  end

  defp page_title(:show), do: "Show Game server"
  defp page_title(:edit), do: "Edit Game server"
end
