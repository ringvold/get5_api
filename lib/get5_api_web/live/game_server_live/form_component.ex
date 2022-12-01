defmodule Get5ApiWeb.GameServerLive.FormComponent do
  use Get5ApiWeb, :live_component

  alias Get5Api.GameServers

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage game_server records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="game_server-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="name" />
        <.input field={{f, :host}} type="text" label="host" />
        <.input field={{f, :port}} type="text" label="port" />
        <.input field={{f, :rcon_password}} type="password" label="RCON password"
          placeholder="Fill to change password. Leave blank to keep current" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Game server</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

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
         |> push_navigate(to: socket.assigns.navigate)}

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
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
