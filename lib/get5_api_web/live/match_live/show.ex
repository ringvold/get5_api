defmodule Get5ApiWeb.MatchLive.Show do
  use Get5ApiWeb, :live_view
  require Logger

  alias Get5Api.GameServers.Get5Client
  alias Get5Api.Matches

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, status: nil)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:match, Matches.get_match!(id))}
  end

  @impl true
  def handle_event("get_status", _params, socket) do
    case Get5Client.status(socket.assigns.match.game_server) do
      {:ok, resp} ->
        Logger.debug(resp)

        {:noreply,
         socket
         |> assign(status: resp)}

      {:error, msg} ->
        {:noreply,
         socket
         |> put_flash(:error, msg)}
    end
  end

  @impl true
  def handle_event("start_match", _params, socket) do
    case Get5Client.start_match(socket.assigns.match) do
      {:ok, resp} ->
        Logger.debug(resp)

        {:noreply,
         socket
         |> put_flash(:info, "Match started")
         |> assign(status: resp)}

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
         |> put_flash(:info, "Match ended")}

      {:error, msg} ->
        {:noreply,
         socket
         |> put_flash(:error, msg)}
    end
  end

  defp page_title(:show), do: "Show Match"
  defp page_title(:edit), do: "Edit Match"
end
