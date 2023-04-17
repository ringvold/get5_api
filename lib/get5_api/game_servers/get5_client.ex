defmodule Get5Api.GameServers.Get5Client do
  alias Get5Api.GameServers.GameServer
  alias Get5Api.GameServers.Rcon
  alias Get5Api.Encryption
  alias Get5ApiWeb.Endpoint
  require Logger

  def start_match(match) do
    url = "#{Endpoint.url()}/matches/#{match.id}/match-config"
    command = "get5_loadmatch_url \"#{url}\" \"Authorization\" \"Bearer #{match.api_key}\""
    Logger.info("Starting match on server #{match.game_server.name}")

    with {:ok, conn} <- connect(match.game_server),
         {:ok, con, _result} <- Rcon.exec(conn, command),
         # Wait for match config to be fetched and match started before checking status.
         # Later we will get event from server and can skip the waiting.
         Process.sleep(1000),
         {:ok, result} <- status(match.game_server, con) do
      {:ok, result}
    end
  end

  def end_match(match) do
    with {:ok, conn} <- connect(match.game_server),
         {:ok, _con, res} <- Rcon.exec(conn, "get5_endmatch") do
      cond do
        String.contains?(res, "An admin force-ended the match") ->
          {:ok, "Match ended"}

        String.contains?(res, "No match is configured; nothing to end") ->
          {:error, "No match is configured; nothing to end"}

        true ->
          {:error, "Failed to end match"}
      end
    else
      err ->
        Logger.error("Failed to end match: #{inspect(err)}")
        {:error, "Failed to end match"}
    end
  end

  def status(game_server, conn \\ nil) do
    if conn != nil do
      _status(conn)
    else
      case connect(game_server) do
        {:ok, conn} -> _status(conn)
        err -> err
      end
    end
  end

  def run(server, command) do
    with {:ok, conn} <- connect(server),
         {:ok, _con, res} <- Rcon.exec(conn, command) do
      {:ok, res}
    else
      err ->
        Logger.error("Failed to run command `#{command}`: #{inspect(err)}")
        {:error, "Failed to run command `#{command}`"}
    end
  end

  defp _status(conn) do
    with {:ok, _con, response} <- RCON.Client.exec(conn, "get5_status"),
         {:ok, response} <- response_to_json(response) do
      {:ok, response}
    end
  end

  defp response_to_json(response) do
    response
    |> String.split("\nL")
    |> hd
    |> Jason.decode()
  end

  @spec connect(%GameServer{}) :: tuple()
  def connect(server) do
    password = Encryption.decrypt(server.encrypted_password)

    case Rcon.connect(server.host, password, server.port) do
      {:ok, conn} ->
        {:ok, conn}

      {:error, :econnrefused} ->
        # Move to connect func?
        {:error, "Server refused the connection. Is it online?"}

      {:error, err} ->
        {:error, err}
    end
  end
end
