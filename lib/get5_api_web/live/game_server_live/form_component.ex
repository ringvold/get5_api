defmodule Get5ApiWeb.GameServerLive.FormComponent do
  use Get5ApiWeb, :live_component

  alias Get5Api.GameServers

  @impl true
  def update(%{game_server: game_server} = assigns, socket) do
    changeset = GameServers.change_game_server(game_server)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"game_server" => game_server_params}, socket) do
    changeset =
      socket.assigns.game_server
      |> GameServers.change_game_server(game_server_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"game_server" => game_server_params}, socket) do
    save_game_server(socket, socket.assigns.action, game_server_params)
  end

  defp save_game_server(socket, :edit, game_server_params) do
    case GameServers.update_game_server(socket.assigns.game_server, game_server_params) do
      {:ok, _game_server} ->
        {:noreply,
         socket
         |> put_flash(:info, "Game server updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_game_server(socket, :new, game_server_params) do
    case GameServers.create_game_server(game_server_params) do
      {:ok, _game_server} ->
        {:noreply,
         socket
         |> put_flash(:info, "Game server created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
