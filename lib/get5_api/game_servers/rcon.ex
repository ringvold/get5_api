defmodule Get5Api.GameServers.Rcon do
  def connect(host, password, port \\ "27015") do
    {port, _} = Integer.parse(port)

    case RCON.Client.connect(host, port, multi: false) do
      {:ok, con} ->
        case RCON.Client.authenticate(con, password) do
          {:ok, conn, true} ->
            {:ok, conn}

          {:ok, _con, false} ->
            {:error, :authentication_failed}
        end

      res ->
        res
        # {:error, msg }
    end
  end

  def exec(conn, command) do
    RCON.Client.exec(conn, command)
  end

  def status(conn) do
    RCON.Client.exec(conn, "status")
  end
end
