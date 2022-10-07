defmodule Get5ApiWeb.MatchLive.FormComponent do
  use Get5ApiWeb, :live_component

  alias Get5Api.Matches
  alias Get5Api.Teams
  alias Get5Api.GameServers

  @impl true
  def update(%{match: match} = assigns, socket) do
    changeset = Matches.change_match(match)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)
      |> assign(:teams, Teams.list_teams())
      |> assign(:servers, GameServers.list_game_servers())
    }
  end

  @impl true
  def handle_event("validate", %{"match" => match_params}, socket) do
    changeset =
      socket.assigns.match
      |> Matches.change_match(match_params)
      |> Map.put(:action, :validate)

    IO.inspect(changeset)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"match" => match_params}, socket) do
    save_match(socket, socket.assigns.action, match_params)
  end

  defp save_match(socket, :edit, match_params) do
    case Matches.update_match(socket.assigns.match, match_params) do
      {:ok, _match} ->
        {:noreply,
         socket
         |> put_flash(:info, "Match updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_match(socket, :new, match_params) do
    case Matches.create_match(match_params) do
      {:ok, _match} ->
        {:noreply,
         socket
         |> put_flash(:info, "Match created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)

        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
