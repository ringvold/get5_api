defmodule Get5ApiWeb.MatchLive.FormComponent do
  use Get5ApiWeb, :live_component

  alias Get5Api.Teams
  alias Get5Api.GameServers

  alias Get5Api.Matches

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage match records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="match-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={{f, :team1_id}}
          type="select"
          label="Team 1"
          prompt="Choose a value"
          options={Enum.map(@teams, &{&1.name, &1.id})}
        />

        <.input
          field={{f, :team2_id}}
          type="select"
          label="Team 2"
          prompt="Choose a value"
          options={Enum.map(@teams, &{&1.name, &1.id})}
        />

        <.input
          field={{f, :game_server_id}}
          type="select"
          label="Server"
          prompt="Choose a value"
          options={Enum.map(@servers, &{&1.name, &1.id})}
        />

        <.input
          field={{f, :side_type}}
          type="select"
          label="Side type"
          prompt="Who starts the match/veto?"
          options={Ecto.Enum.values(Get5Api.Matches.Match, :side_type)}
        />

        <.input
          field={{f, :series_type}}
          type="select"
          label="Series type"
          prompt="Who many maps will be played?"
          options={Ecto.Enum.values(Get5Api.Matches.Match, :series_type)}
        />

        <.input
          field={{f, :map_list}}
          type="select"
          label="map_list"
          prompt="Choose a value"
          options={[
            :all,
            :de_ancient,
            :de_dust2,
            :de_inferno,
            :de_nuke,
            :de_mirage,
            :de_overplass,
            :de_train,
            :de_tuscan,
            :de_vertigo
          ]}
          multiple
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Match</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{match: match} = assigns, socket) do
    changeset = Matches.change_match(match)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:teams, Teams.list_teams())
     |> assign(:servers, GameServers.list_game_servers())}
  end

  @impl true
  def handle_event("validate", %{"match" => match_params}, socket) do
    changeset =
      socket.assigns.match
      |> Matches.change_match(match_params)
      |> Map.put(:action, :validate)

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
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_match(socket, :new, match_params) do
    case Matches.create_and_start_match(match_params) do
      {:ok, _match} ->
        {:noreply,
         socket
         |> put_flash(:info, "Match created and started on the server")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
