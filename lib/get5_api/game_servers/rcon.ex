defmodule Get5Api.GameServers.Rcon do
  require Logger

  def connect(host, password, port \\ "27015") do
    {port, _} = Integer.parse(port)

    case RCON.Client.connect(host, port) do
      {:ok, con} ->
        case RCON.Client.authenticate(con, password) do
          {:ok, conn, true} ->
            {:ok, conn}

          {:ok, _con, false} ->
            {:error, :authentication_failed}

          {:error, error} ->
            Logger.error("Rcon authentication failed with error", error)
            {:error, :authentication_failed}
        end

      {:error, error} ->
        # Logger.error("Socket error: #{IO.inspect(error)}")
        IO.inspect error
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
