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
        for={@form}
        id="game_server-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:host]} type="text" label="Host" />
        <.input field={@form[:port]} type="text" label="Port" />
        <.input field={@form[:in_use]} type="checkbox" label="In use" />
        <.input field={@form[:public]} type="checkbox" label="Public" />
        <.input
          field={@form[:rcon_password]}
          type="password"
          label="RCON password"
          placeholder="Fill to change password. Leave blank to keep current"
        />
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
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"game_server" => game_server_params}, socket) do
    changeset =
      socket.assigns.game_server
      |> GameServers.change_game_server(game_server_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"game_server" => game_server_params}, socket) do
    save_game_server(socket, socket.assigns.action, game_server_params)
  end

  defp save_game_server(socket, :edit, game_server_params) do
    case GameServers.update_game_server(socket.assigns.game_server, game_server_params) do
      {:ok, game_server} ->
        notify_parent({:saved, game_server})

        {:noreply,
         socket
         |> put_flash(:info, "Game server updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_game_server(socket, :new, game_server_params) do
    case GameServers.create_game_server(game_server_params) do
      {:ok, game_server} ->
        notify_parent({:saved, game_server})

        {:noreply,
         socket
         |> put_flash(:info, "Game server created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
