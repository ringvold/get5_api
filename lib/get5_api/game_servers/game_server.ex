defmodule Get5Api.GameServers.GameServer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Get5Api.Matches.Match
  alias Get5Api.Encryption

  schema "game_servers" do
    field :host, :string
    field :in_use, :boolean, default: false
    field :name, :string
    field :port, :integer
    field :gotv_port, :integer
    field :rcon_password, :string, virtual: true, redact: true
    field :encrypted_password, :string, redact: true

    has_many :matches, Match

    timestamps()
  end

  @doc false
  def changeset(game_server, attrs, opts \\ []) do
    game_server
    |> cast(attrs, [:name, :host, :port, :gotv_port, :in_use, :rcon_password])
    |> validate_required([:name, :host, :port, :rcon_password])
    |> validate_password(opts)
  end

  @doc false
  def update_changeset(game_server, attrs, opts \\ []) do
    changeset =
      game_server
      |> cast(attrs, [:name, :host, :port, :gotv_port, :in_use, :rcon_password])
      |> validate_required([:name, :host, :port])

    password_cs = rcon_password_changeset(game_server, attrs, opts)

    case fetch_change(changeset, :rcon_password) do
      :error ->
        changeset

      {:ok, _value} ->
        merge(changeset, password_cs)
    end
  end

  def rcon_password_changeset(game_server, attrs, opts \\ []) do
    game_server
    |> cast(attrs, [:rcon_password])
    |> validate_password(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:rcon_password])
    |> maybe_encrypt_password(opts)
  end

  defp maybe_encrypt_password(changeset, opts) do
    encrypt_password? = Keyword.get(opts, :encrypt_password, true)
    password = get_change(changeset, :rcon_password)

    if encrypt_password? && password && changeset.valid? do
      changeset
      |> put_change(:encrypted_password, Encryption.encrypt(password))
      |> delete_change(:rcon_password)
    else
      changeset
    end
  end
end
