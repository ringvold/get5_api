defmodule Get5ApiWeb.GameServerLive.Show do
  require Logger
  use Get5ApiWeb, :live_view

  alias Get5Api.GameServers
  alias Get5Api.Encryption
  alias Get5Api.GameServers.Get5Client

  @impl true
  def mount(_params, _session, socket) do
    server = socket.assigns.entity

    {:ok,
     socket
     |> assign_new(:game_server, fn %{entity: entity} -> entity end)
     |> assign(status_fetch_errors: 0)
     |> assign_async(:status, fn -> get_status(server) end)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    game_server = socket.assigns.entity || GameServers.get_game_server!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:game_server, game_server)
     |> assign(:show_password, false)
     |> assign(:rcon_password, "")
      }
  end

  @impl true
  def handle_event("show_password", _params, socket) do
    if socket.assigns.game_server.user_id == socket.assigns.current_user.id do
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
           Encryption.decrypt(socket.assigns.game_server.encrypted_password)
         )}
      end
    else
      {:noreply,
       socket
       |> put_flash(:error, gettext("You are not allowed to view rcon password"))}
    end
  end

  @impl true
  def handle_info({:get_status, game_server}, socket) do
    if socket.assigns.status_fetch_errors < 4 do
      case Get5Client.status(game_server) do
        {:ok, resp} ->
          {:noreply,
           socket
           |> assign(status: resp)}

        {:error, msg} ->
          Logger.error(%{message: msg})

          {:noreply,
           socket
           |> assign(status: nil, status_fetches: socket.assigns.status_fetch_errors + 1)
           |> put_flash(:error, "Could not fetch get5 status from server")}
      end
    end
  end

  defp get_status(server) do
    {:ok, status} = Get5Client.status(server)
    {:ok, %{status: status}}
  end

  def get_entity_for_id(socket, id) do
    assign_new(socket, :entity, fn ->
      GameServers.get_game_server!(id)
    end)
  end

  def redirect_url() do
    ~p"/matches"
  end

  defp page_title(:show), do: "Show Game server"
  defp page_title(:edit), do: "Edit Game server"
end
