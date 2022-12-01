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
     |> assign(:team, Teams.get_team!(id))
     |> assign(:player, %Player{})}
  end

  defp page_title(:show), do: "Show Team"
  defp page_title(:edit), do: "Edit Team"
  defp page_title(:add_player), do: "Add Player"
end
