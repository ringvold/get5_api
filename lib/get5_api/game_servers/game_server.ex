defmodule Get5Api.GameServers.GameServer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Get5Api.Matches.Match

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "game_servers" do
    field :host, :string
    field :in_use, :boolean, default: false
    field :name, :string
    field :port, :string
    field :rcon_password, :string

    has_many :matches, Match

    timestamps()
  end

  @doc false
  def changeset(game_server, attrs) do
    game_server
    |> cast(attrs, [:name, :host, :port, :rcon_password])
    |> validate_required([:name, :host, :port, :rcon_password])
  end
end
