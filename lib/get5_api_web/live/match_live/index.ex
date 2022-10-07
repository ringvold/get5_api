defmodule Get5ApiWeb.MatchLive.Index do
  use Get5ApiWeb, :live_view

  alias Get5Api.Matches
  alias Get5Api.Matches.Match
  alias Get5Api.GameServers
  alias Get5Api.Teams

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:matches, list_matches())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Match")
    |> assign(:match, Matches.get_match!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Match")
    |> assign(:match, %Match{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Matches")
    |> assign(:match, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    match = Matches.get_match!(id)
    {:ok, _} = Matches.delete_match(match)

    {:noreply, assign(socket, :matches, list_matches())}
  end

  defp list_matches do
    Matches.list_matches()
  end
end
