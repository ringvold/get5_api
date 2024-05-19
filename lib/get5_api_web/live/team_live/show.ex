defmodule Get5ApiWeb.TeamLive.Show do
  use Get5ApiWeb, :live_view

  alias Get5Api.Teams
  alias Get5Api.Teams.Player

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign_new(:team, fn %{entity: entity} -> entity end)}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    {:noreply,
     socket
     |> apply_action(socket.assigns.live_action, params)
     |> assign_new(:team, fn ->
       Teams.get_team!(id)
     end)}
  end

  @impl true
  def handle_event("delete_player", %{"id" => id}, socket) do
    case Teams.remove_player(socket.assigns.current_user, socket.assigns.team, %Player{
           steam_id: id
         }) do
      {:ok, team} ->
        {:noreply, assign(socket, :team, team)}

      {:error, :unauthorized} ->
        {:noreply,
         socket
         |> put_flash(:error, gettext("You are not authorized to remove players from this team"))}

      {:error, _} ->
        {:noreply, socket |> put_flash(:error, gettext("Could not remove player from team"))}
    end
  end

  def get_entity_for_id(socket, id) do
    assign_new(socket, :entity, fn ->
      Teams.get_team!(id)
    end)
  end

  def redirect_url() do
    ~p"/teams"
  end

  defp apply_action(socket, :edit, _) do
    socket
    |> assign(:page_title, "Edit Team")
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Show Team")
  end

  defp apply_action(socket, :edit_player, %{"player_id" => id}) do
    socket
    |> assign(:page_title, "Edit Player")
    |> assign(
      :player,
      socket.assigns.team.players |> Enum.find(&(&1.id == id))
    )
  end

  defp apply_action(socket, :add_player, _params) do
    socket
    |> assign(:page_title, "Add Player")
    |> assign(:player, %Player{})
  end
end
