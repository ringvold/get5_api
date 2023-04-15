defmodule Get5ApiWeb.TeamLive.Index do
  use Get5ApiWeb, :live_view

  alias Get5Api.Teams
  alias Get5Api.Teams.Team

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :teams, Teams.list_teams())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Team")
    |> assign(:team, Teams.get_team!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Team")
    |> assign(:team, %Team{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Teams")
    |> assign(:team, nil)
  end

  @impl true
  def handle_info({Get5ApiWeb.TeamLive.FormComponent, {:saved, game_server}}, socket) do
    {:noreply, stream_insert(socket, :game_servers, game_server)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    team = Teams.get_team!(id)
    {:ok, _} = Teams.delete_team(team)

    {:noreply, stream_delete(socket, :teams, team)}
  end
end
