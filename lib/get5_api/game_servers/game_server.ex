defmodule Get5Api.GameServers.GameServer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Get5Api.Accounts.User
  alias Get5Api.Matches.Match
  alias Get5Api.Encryption

  schema "game_servers" do
    field :host, :string
    field :in_use, :boolean, default: false
    field :public, :boolean, default: false
    field :name, :string
    field :port, :integer
    field :gotv_port, :integer
    field :rcon_password, :string, virtual: true, redact: true
    field :encrypted_password, :string, redact: true

    has_many :matches, Match
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(game_server, attrs, opts \\ []) do
    game_server
    |> cast(attrs, [:user_id, :name, :host, :port, :gotv_port, :in_use, :public, :rcon_password])
    |> cast_assoc(:user)
    |> validate_required([:name, :host, :port, :rcon_password, :user_id])
    |> validate_password(opts)
    |> validate_host()
  end

  @doc false
  def update_changeset(game_server, attrs, opts \\ []) do
    changeset =
      game_server
      |> cast(attrs, [:name, :host, :port, :gotv_port, :in_use, :public, :rcon_password])
      |> validate_required([:name, :host, :port])
      |> validate_host()

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

  def validate_host(changeset) do
    host = get_change(changeset, :host)

    if host && (Regex.match?(domain_regex(), host) || Regex.match?(ip_regex(), host)) do
      changeset
    else
      add_error(changeset, :host, "Invalid host")
    end
  end

  defp domain_regex() do
    ~r/^((?!-)[A-Za-z0-9-]{1,63}(?<!-)\.)+[A-Za-z]{2,6}$/ # (\:[0-9]{4,5})?
  end

  defp ip_regex() do
    ~r/^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/
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
