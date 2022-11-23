defmodule Get5ApiWeb.GameServerLive.Show do
  use Get5ApiWeb, :live_view

  alias Get5Api.GameServers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:game_server, GameServers.get_game_server!(id))}
  end

  defp page_title(:show), do: "Show Game server"
  defp page_title(:edit), do: "Edit Game server"
end
