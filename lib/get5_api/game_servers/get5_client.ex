defmodule Get5Api.GameServers.Get5Client do
  alias Get5Api.GameServers.GameServer
  alias Get5Api.GameServers.Rcon
  alias Get5Api.Encryption
  alias Get5ApiWeb.Endpoint
  require Logger

  def start_match(match) do
    base_url = "#{Endpoint.url()}/matches/#{match.id}"
    load_command = "get5_loadmatch_url \"#{base_url}/match-config\" \"Authorization\" \"Bearer #{match.api_key}\""
    Logger.info("Starting match on server #{match.game_server.name}")

    with {:ok, conn} <- connect(match.game_server),
         {:ok, conn, result} <- set_log_url(conn, base_url, match.api_key),
         {:ok, conn, result} <- Rcon.exec(conn, load_command) do
      message =
        result
        |> String.split("\nL")
        |> hd

      cond do
        String.contains?(message, "Loading match configuration") ->
          {:ok, message}

        String.contains?(message, "Cannot load a match config when another is already loaded") ->
          {:error, :other_match_already_loaded}

        true ->
          {:error, "Failed to start match"}
      end
    else
      err ->
        Logger.error("Failed to start match: #{inspect(err)}")
        {:error, "Failed to start match"}
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

  def set_log_url(conn, base_url, api_key) do
    url_cmd = "get5_remote_log_url \"#{base_url}/events\""
    header_cmd = "get5_remote_log_header_value \"Bearer #{api_key}\""

    with {:ok, conn, res} <- Rcon.exec(conn, url_cmd) do
      Rcon.exec(conn, header_cmd)
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
end
