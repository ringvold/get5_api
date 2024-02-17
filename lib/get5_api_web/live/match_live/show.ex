defmodule Get5ApiWeb.MatchLive.Show do
  alias Phoenix.LiveView.AsyncResult
  use Get5ApiWeb, :live_view
  require Logger

  alias Get5Api.GameServers.Get5Client
  alias Get5Api.Matches
  alias Get5Api.Stats

  @topic "match_events"

  @impl true
  def mount(_params, _session, socket) do
    Get5ApiWeb.Endpoint.subscribe(@topic)

    {:ok,
     assign(socket, stats: nil)
     |> assign_new(:match, fn %{entity: entity} -> entity end)
     |> assign(:status, AsyncResult.loading())}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    match = socket.assigns.entity || Matches.get_match!(id)
    map_stats = Stats.get_by_match(id)
    player_stats = Stats.player_stats_by_match(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:match, match)
     |> assign(:map_stats, map_stats)
     |> assign(:player_stats, player_stats)
     |> start_async(:get_status, fn -> Get5Client.status(socket.assigns.entity.game_server) end)}
  end

  @impl true
  def handle_event("get_status", _params, socket) do
    {:noreply,
     socket
     |> assign(status: AsyncResult.loading())
     |> start_async(:get_status, fn -> Get5Client.status(socket.assigns.match.game_server) end)}
  end

  @impl true
  def handle_event("start_match", _params, socket) do
    if socket.assigns.match.user_id == socket.assigns.current_user.id do
      {:noreply,
       socket
       |> start_async(:start_match, fn -> Get5Client.start_match(socket.assigns.match) end)}
    else
      {:noreply,
       socket
       |> put_flash(:error, gettext("You are not allowed to start this match"))}
    end
  end

  def handle_async(:start_match, {:ok, {:ok, _resp}}, socket) do
    {:noreply,
     socket
     |> start_async(:get_status, fn ->
       Get5Client.status(socket.assigns.match.game_server)
     end)
     |> put_flash(:info, gettext("Match sendt to server"))}
  end

  def handle_async(:start_match, {:ok, {:error, error}}, socket) do
    case error do
      :nxdomain ->
        {:noreply,
         socket
         |> start_async(:get_status, fn ->
           Get5Client.status(socket.assigns.match.game_server)
         end)
         |> put_flash(
           :error,
           gettext("Domain %{host} does not exist or could not be reached",
             host: socket.assigns.match.game_server.host
           )
         )}

      :other_match_already_loaded ->
        {:noreply,
         socket
         |> start_async(:get_status, fn ->
           Get5Client.status(socket.assigns.match.game_server)
         end)
         |> put_flash(
           :error,
           gettext("A match is already loaded on the server")
         )}

      err ->
        {:noreply,
         socket
         |> start_async(:get_status, fn ->
           Get5Client.status(socket.assigns.match.game_server)
         end)
         |> put_flash(:error, gettext("Failed to start match"))}
    end
  end

  @impl true
  def handle_event("end_match", _params, socket) do
    if socket.assigns.match.user_id == socket.assigns.current_user.id do
      {:noreply,
       socket
       |> start_async(:end_match, fn -> Get5Client.end_match(socket.assigns.match) end)}
    else
      {:noreply,
       socket
       |> put_flash(:error, gettext("You are not allowed to end this match"))}
    end
  end

  def handle_async(:end_match, {:ok, {:ok, msg}}, socket) do
    {:noreply,
     socket
     |> start_async(:get_status, fn ->
       Get5Client.status(socket.assigns.match.game_server)
     end)
     |> put_flash(:info, gettext("Match ended"))}
  end

  def handle_async(:end_match, {:ok, {:error, error}}, socket) do
    case error do
      :nxdomain ->
        {:noreply,
         socket
         |> put_flash(
           :error,
           gettext("Domain %{host} does not exist or could not be reached",
             host: socket.assigns.match.game_server.host
           )
         )}

      msg ->
        {:noreply,
         socket
         |> put_flash(:error, msg)}
    end
  end

  def handle_async(:end_match, {:exit, reason}, socket) do
    {:noreply,
     socket
     |> assign(status: AsyncResult.failed(socket.assigns.status, reason))
     |> put_flash(:error, reason)}
  end

  def handle_async(:get_status, {:ok, {:ok, resp}}, socket) do
    {:noreply,
     socket
     |> assign(status: AsyncResult.ok(resp))}
  end

  def handle_async(:get_status, {:ok, {:error, msg}}, socket) do
    case msg do
      :nxdomain ->
        {:noreply,
         socket
         |> assign(status: AsyncResult.failed(socket.assigns.status, :nxdomain))
         |> put_flash(
           :error,
           gettext("Domain %{host} does not exist or could not be reached",
             host: socket.assigns.match.game_server.host
           )
         )}

      msg ->
        {:noreply,
         socket
         |> assign(status: AsyncResult.failed(socket.assigns.status, msg))
         |> put_flash(:error, msg)}
    end
  end

  def handle_async(:status, {:exit, reason}, socket) do
    {:noreply,
     socket
     |> assign(status: AsyncResult.failed(socket.assigns.status, reason))
     |> put_flash(:error, reason)}
  end

  def handle_info(%{topic: @topic, payload: payload}, socket) do
    IO.puts("HANDLE BROADCAST FOR #{@topic}")
    dbg(payload)

    {:noreply,
     socket
     |> put_flash(
       :error,
       payload.reason
     )}
  end

  def get_entity_for_id(socket, id) do
    assign_new(socket, :entity, fn ->
      Matches.get_match!(id)
    end)
  end

  def redirect_url() do
    ~p"/matches"
  end

  defp page_title(:show), do: "Show Match"
  defp page_title(:edit), do: "Edit Match"
end
