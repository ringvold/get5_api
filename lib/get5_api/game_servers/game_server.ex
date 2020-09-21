defmodule Get5Api.GameServers.GameServer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "game_servers" do
    field :host, :integer
    field :in_use, :boolean, default: false
    field :name, :string
    field :port, :string
    field :rcon_password, :string

    timestamps()
  end

  @doc false
  def changeset(game_server, attrs) do
    game_server
    |> cast(attrs, [:name, :host, :port, :rcon_password, :in_use])
    |> validate_required([:name, :host, :port, :rcon_password, :in_use])
  end
end
