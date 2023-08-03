defmodule Get5ApiWeb.TeamLive.PlayerFormComponent do
  use Get5ApiWeb, :live_component

  alias Get5Api.Teams

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Add player by steam id. Name is optional. If not set name defaults to the players current steam name.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="player-form"
        phx-target={@myself}
        phx-change="validate_player"
        phx-submit="save_player"
      >
        <.input field={@form[:steam_id]} type="text" label="SteamID" />
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Add player</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{player: player} = assigns, socket) do
    changeset = Teams.change_player(player)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_player_form(changeset)}
  end

  @impl true
  def handle_event("validate_player", %{"player" => player_params}, socket) do
    changeset =
      socket.assigns.player
      |> Teams.change_player(player_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_player_form(socket, changeset)}
  end

  def handle_event("save_player", %{"player" => player_params}, socket) do
    save_player(socket, socket.assigns.action, player_params)
  end

  defp save_player(socket, :add_player, player_params) do
    case Teams.add_player(socket.assigns.team, socket.assigns.player, player_params) do
      {:ok, _team} ->
        {:noreply,
         socket
         |> put_flash(:info, "Player added successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_player_form(socket, changeset|> Map.put(:action, :validate))}
    end
  end

  defp assign_player_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset, as: :player))
  end
end
