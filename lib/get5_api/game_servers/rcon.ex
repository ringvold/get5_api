defmodule Get5Api.GameServers.Rcon do
  require Logger

  @type connection :: {Socket.TCP.t(), Packet.id(), boolean()}

  @spec connect(Socket.Address.t(), :inet.port_number()) ::
          {:ok, connection} | {:error, %Socket.Error{} | term()}
  def connect(host, password, port \\ "27015") do
    {port, _} = Integer.parse(port)

    case RCON.Client.connect(host, port, multi: true, timeout: 3000) do
      {:ok, con} ->
        case RCON.Client.authenticate(con, password) |> dbg do
          {:ok, conn, true} ->
            {:ok, conn}

          {:ok, _con, false} ->
            {:error, :authentication_failed}

          {:error, error} ->
            Logger.error("Rcon authentication failed with error", error)
            {:error, :authentication_failed}
        end

      {:error, error} ->
        Logger.error("Error connecting to RCON: #{IO.inspect(error)}")
        {:error, error}
    end
  end

  def exec(conn, command) do
    RCON.Client.exec(conn, command)
  end

  def status(conn) do
    RCON.Client.exec(conn, "status")
  end
end
