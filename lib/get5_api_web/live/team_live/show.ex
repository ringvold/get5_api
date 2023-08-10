defmodule Get5ApiWeb.TeamLive.Show do
  use Get5ApiWeb, :live_view

  alias Get5Api.Teams
  alias Get5Api.Teams.Player

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign_new(:team, fn ->
       Teams.get_team!(id)
     end)}
  end

  @impl true
  def handle_event("delete_player", %{"id" => id}, socket) do
    {:ok, team} = Teams.remove_player(socket.assigns.team, %Player{steam_id: id})

    {:noreply, assign(socket, :team, team)}
  end

  def get_entity_for_id(id, socket) do
    assign_new(socket, :team, fn ->
      Teams.get_team!(id)
    end)
    |> assign_new(:owner_id, fn %{team: team} -> team.user_id end)
  end

  def redirect_url() do
    ~p"/teams"
  end

  defp page_title(:show), do: "Show Team"
  defp page_title(:edit), do: "Edit Team"
  defp page_title(:add_player), do: "Add Player"
end
