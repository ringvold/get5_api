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
    game_server = socket.assigns.entity.game_server

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:match, match)
     |> assign(:map_stats, map_stats)
     |> assign(:player_stats, player_stats)
     |> start_async(:get_status, fn -> Get5Client.status(game_server) end)}
  end

  @impl true
  def handle_event("get_status", _params, socket) do
    game_server = socket.assigns.match.game_server

    {:noreply,
     socket
     |> assign(status: AsyncResult.loading())
     |> start_async(:get_status, fn -> Get5Client.status(game_server) end)}
  end

  @impl true
  def handle_event("start_match", _params, socket) do
    if socket.assigns.match.user_id == socket.assigns.current_user.id do
      match = socket.assigns.match

      {:noreply,
       socket
       |> start_async(:start_match, fn -> Get5Client.start_match(match) end)}
    else
      {:noreply,
       socket
       |> put_flash(:error, gettext("You are not allowed to start this match"))}
    end
  end

  @impl true
  def handle_event("end_match", _params, socket) do
    if socket.assigns.match.user_id == socket.assigns.current_user.id do
      match = socket.assigns.match

      {:noreply,
       socket
       |> start_async(:end_match, fn -> Get5Client.end_match(match) end)}
    else
      {:noreply,
       socket
       |> put_flash(:error, gettext("You are not allowed to end this match"))}
    end
  end

  @impl true
  def handle_async(:start_match, {:ok, {:ok, _resp}}, socket) do
    game_server = socket.assigns.match.game_server

    {:noreply,
     socket
     |> start_async(:get_status, fn ->
       Get5Client.status(game_server)
     end)
     |> put_flash(:info, gettext("Match sendt to server"))}
  end

  @impl true
  def handle_async(:start_match, {:ok, {:error, error}}, socket) do
    game_server = socket.assigns.match.game_server

    case error do
      :nxdomain ->
        {:noreply,
         socket
         |> start_async(:get_status, fn ->
           Get5Client.status(game_server)
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
           Get5Client.status(game_server)
         end)
         |> put_flash(
           :error,
           gettext("A match is already loaded on the server")
         )}

      :plugin_not_installed ->
        {:noreply,
         socket
         |> start_async(:get_status, fn ->
           Get5Client.status(game_server)
         end)
         |> put_flash(
           :error,
           plugin_not_installed_message()
         )}

      _err ->
        {:noreply,
         socket
         |> start_async(:get_status, fn ->
           Get5Client.status(game_server)
         end)
         |> put_flash(:error, gettext("Failed to start match"))}
    end
  end

  @impl true
  def handle_async(:start_match, {:exit, reason}, socket) do
    Logger.error("start_match async task crashed: #{inspect(reason)}")

    {:noreply,
     socket
     |> put_flash(:error, gettext("Something went wrong while starting the match"))}
  end

  @impl true
  def handle_async(:end_match, {:ok, {:ok, _msg}}, socket) do
    game_server = socket.assigns.match.game_server

    {:noreply,
     socket
     |> start_async(:get_status, fn ->
       Get5Client.status(game_server)
     end)
     |> put_flash(:info, gettext("Match ended"))}
  end

  @impl true
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

      :plugin_not_installed ->
        {:noreply,
         socket
         |> put_flash(
           :error,
           plugin_not_installed_message()
         )}

      msg ->
        {:noreply,
         socket
         |> put_flash(:error, to_string(msg))}
    end
  end

  @impl true
  def handle_async(:end_match, {:exit, reason}, socket) do
    Logger.error("end_match async task crashed: #{inspect(reason)}")

    {:noreply,
     socket
     |> put_flash(:error, gettext("Something went wrong while ending the match"))}
  end

  @impl true
  def handle_async(:get_status, {:ok, {:ok, resp}}, socket) do
    {:noreply,
     socket
     |> assign(status: AsyncResult.ok(resp))}
  end

  @impl true
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

      :plugin_not_installed ->
        {:noreply,
         socket
         |> assign(status: AsyncResult.failed(socket.assigns.status, :plugin_not_installed))
         |> put_flash(
           :error,
           plugin_not_installed_message()
         )}

      msg ->
        {:noreply,
         socket
         |> assign(status: AsyncResult.failed(socket.assigns.status, msg))
         |> put_flash(:error, to_string(msg))}
    end
  end

  @impl true
  def handle_async(:get_status, {:exit, reason}, socket) do
    Logger.error("get_status async task crashed: #{inspect(reason)}")

    {:noreply,
     socket
     |> assign(status: AsyncResult.failed(socket.assigns.status, reason))
     |> put_flash(:error, gettext("Something went wrong while fetching server status"))}
  end

  @impl true
  def handle_info(
        %{topic: @topic, event: "match_config_loaded", payload: %{match_id: match_id}},
        socket
      ) do
    if match_id == socket.assigns.match.id do
      game_server = socket.assigns.match.game_server

      {:noreply,
       socket
       |> start_async(:get_status, fn -> Get5Client.status(game_server) end)
       |> put_flash(:info, gettext("Match config loaded by server, match is starting"))}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info(
        %{topic: @topic, event: "match_config_load_fail", payload: payload},
        socket
      ) do
    if payload.match_id == socket.assigns.match.id do
      {:noreply,
       socket
       |> put_flash(:error, payload.reason)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info(%{topic: @topic}, socket) do
    {:noreply, socket}
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
