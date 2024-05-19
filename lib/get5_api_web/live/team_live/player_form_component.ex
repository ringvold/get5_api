defmodule Get5ApiWeb.TeamLive.PlayerFormComponent do
  use Get5ApiWeb, :live_component

  require Logger

  alias Get5Api.Teams
  alias Get5Api.Steam

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          Add player by steam id. Name is optional. If not set name defaults to the players current steam name.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="player-form"
        phx-target={@myself}
        phx-change="validate_player"
        phx-submit="save_player"
      >
        <.input field={@form[:steam_id]} type="text" phx-debounce="blur" label="SteamID" />
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
    player_params =
      if player_params["steam_id"] == "" do
        player_params
      else
        profile =
          String.trim(player_params["steam_id"])
          |> get_steam_profile()

        case profile do
          {:ok, profile} ->
            Map.put(player_params, "name", profile.steam_id)

          {:error, _error} ->
            player_params
        end
      end

    changeset =
      socket.assigns.player
      |> Teams.change_player(player_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_player_form(socket, changeset)}
  end

  @impl true
  def handle_event("find_steam_name", %{"value" => steam_id}, socket) do
    player_params = %{"steam_id" => steam_id}

    if steam_id == "" do
      {:noreply, socket}
    else
      profile =
        String.trim(steam_id)
        |> get_steam_profile()

      player_params =
        case profile do
          {:ok, profile} ->
            Map.put(player_params, "name", profile.steam_id)

          {:error, _error} ->
            Map.put(player_params, "name", nil)
        end

      changeset =
        socket.assigns.player
        |> Teams.change_player(player_params)
        |> Map.put(:action, :validate)

      {:noreply, assign_player_form(socket, changeset)}
    end
  end

  @impl true
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
        {:noreply, assign_player_form(socket, changeset |> Map.put(:action, :validate))}
    end
  end

  defp save_player(socket, :edit_player, player_params) do
    case Teams.edit_player(socket.assigns.team, socket.assigns.player, player_params) do
      {:ok, _team} ->
        {:noreply,
         socket
         |> put_flash(:info, "Player successfully edited")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_player_form(socket, changeset |> Map.put(:action, :validate))}
    end
  end

  defp assign_player_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset, as: :player))
  end

  defp get_steam_profile(steam_id) do
    try do
      profile =
        steam_id
        |> maybe_convert_steam_id()
        |> Steam.fetch_profile()

      {:ok, profile}
    rescue
      error ->
        Logger.error(error)
        {:error, error}
    end
  end

  defp maybe_convert_steam_id(id) do
    if Steam.is_steamID64?(id) do
      id
    else
      Steam.steam_id_to_steamID64(id)
    end
  end
end
