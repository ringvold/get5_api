defmodule Get5ApiWeb.GameServerLive.Index do
  use Get5ApiWeb, :live_view

  alias Get5Api.GameServers
  alias Get5Api.GameServers.GameServer

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :game_servers, GameServers.list_game_servers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Game server")
    |> assign(:game_server, GameServers.get_game_server!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Game server")
    |> assign(:game_server, %GameServer{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Game servers")
    |> assign(:game_server, nil)
  end

  @impl true
  def handle_info({Get5ApiWeb.GameServerLive.FormComponent, {:saved, game_server}}, socket) do
    {:noreply, stream_insert(socket, :game_servers, game_server)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    game_server = GameServers.get_game_server!(id)
    {:ok, _} = GameServers.delete_game_server(game_server)

    {:noreply, stream_delete(socket, :game_servers, game_server)}
  end
end
