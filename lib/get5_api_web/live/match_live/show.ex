defmodule Get5ApiWeb.MatchLive.Show do
  use Get5ApiWeb, :live_view
  require Logger

  alias Get5Api.GameServers.Get5Client
  alias Get5Api.Matches
  alias Get5Api.Stats

  @topic "match_events"

  @impl true
  def mount(_params, _session, socket) do
    Get5ApiWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, status: nil, stats: nil)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    match = Matches.get_match!(id)
    map_stats = Stats.get_by_match(id)
    player_stats = Stats.player_stats_by_match(id)
    send(self(), {:get_status, match.game_server})

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:match, match)
     |> assign(:map_stats, map_stats)
     |> assign(:player_stats, player_stats)}
  end

  @impl true
  def handle_event("get_status", _params, socket) do
    send(self(), {:get_status, socket.assigns.match.game_server})
    {:noreply, socket |> assign(status: :loading)}
  end

  @impl true
  def handle_event("start_match", _params, socket) do
    case Get5Client.start_match(socket.assigns.match) do
      {:ok, _resp} ->
        send(self(), {:get_status, socket.assigns.match.game_server})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Match sendt to server"))}

      {:error, :nxdomain} ->
        {:noreply,
         socket
         |> assign(status: nil)
         |> put_flash(
           :error,
           gettext("Domain %{host} does not exist or could not be reached",
             host: socket.assigns.match.game_server.host
           )
         )}

      {:error, :other_match_already_loaded} ->
        {:noreply,
         socket
         |> assign(status: nil)
         |> put_flash(
           :error,
           gettext("A match is already loaded on the server")
         )}

      {:error, msg} ->
        {:noreply,
         socket
         |> put_flash(:error, msg)
         |> assign(status: nil)}
    end
  end

  @impl true
  def handle_event("end_match", _params, socket) do
    case Get5Client.end_match(socket.assigns.match) do
      {:ok, _msg} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Match ended"))}

      {:error, :nxdomain} ->
        {:noreply,
         socket
         |> assign(status: nil)
         |> put_flash(
           :error,
           gettext("Domain %{host} does not exist or could not be reached",
             host: socket.assigns.match.game_server.host
           )
         )}

      {:error, msg} ->
        {:noreply,
         socket
         |> assign(status: nil)
         |> put_flash(:error, msg)}
    end
  end

  @impl true
  def handle_info({:get_status, game_server}, socket) do
    case Get5Client.status(game_server) do
      {:ok, resp} ->
        Logger.debug(resp)
        dbg(resp)

        {:noreply,
         socket
         |> assign(status: resp)}

      # TODO: Common/DRY handling of nxdomain error in match events
      {:error, :nxdomain} ->
        {:noreply,
         socket
         |> assign(status: nil)
         |> put_flash(
           :error,
           gettext("Domain %{host} does not exist or could not be reached", host: game_server.host)
         )}

      {:error, msg} ->
        {:noreply,
         socket
         |> assign(status: nil)
         |> put_flash(:error, msg)}
    end
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

  def get_entity_for_id(id, socket) do
    assign_new(socket, :match, fn ->
      Matches.get_match!(id)
    end)
    |> assign_new(:owner_id, fn %{match: match} -> match.user_id end)
  end

  def redirect_url() do
    ~p"/matches"
  end

  defp page_title(:show), do: "Show Match"
  defp page_title(:edit), do: "Edit Match"
end
