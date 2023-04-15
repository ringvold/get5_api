defmodule Get5ApiWeb.TeamLive.FormComponent do
  use Get5ApiWeb, :live_component

  alias Get5Api.Teams

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage team records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="team-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Team</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{team: team} = assigns, socket) do
    changeset = Teams.change_team(team)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"team" => team_params}, socket) do
    changeset =
      socket.assigns.team
      |> Teams.change_team(team_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"team" => team_params}, socket) do
    save_team(socket, socket.assigns.action, team_params)
  end

  defp save_team(socket, :edit, team_params) do
    case Teams.update_team(socket.assigns.team, team_params) do
      {:ok, _team} ->
        {:noreply,
         socket
         |> put_flash(:info, "Team updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_team(socket, :new, team_params) do
    case Teams.create_team(team_params) do
      {:ok, team} ->
        {:noreply,
         socket
         |> put_flash(:info, "Team created successfully")
         |> push_navigate(to: ~p"/teams/#{team.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
