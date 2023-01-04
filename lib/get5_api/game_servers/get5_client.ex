defmodule Get5Api.GameServers.Get5Client do
  alias Get5Api.GameServers.GameServer
  alias Get5Api.GameServers.Rcon
  alias Get5Api.Encryption
  alias Get5ApiWeb.Endpoint
  require Logger

  def start_match(match) do
    url = "#{Endpoint.url()}/matches/#{match.id}/match_config"
    command = "get5_loadmatch_url \"#{url}\" \"Authorization\" \"Bearer #{match.api_key}\""

    with {:ok, conn} <- connect(match.game_server),
         {:ok, con, _result} <- Rcon.exec(conn, command),
         {:ok, result} <- status(con, sleep: true) do
      {:ok, result}
    end
  end

  def end_match(match) do
    {:ok, conn} = connect(match.game_server)
    case Rcon.exec(conn, "get5_endmatch") do
      {:ok, _con, res} ->
        if String.contains?(res, "An admin force-ended the match") do
          {:ok, "Match ended"}
        else
          {:error, "Failed to end match"}
        end

      err ->
        Logger.error("Failed to end match: #{inspect(err)}")
        {:error, "Failed to end match"}
    end
  end

  def status(conn, opt \\ []) do
    # Do polling instead?
    if opt[:sleep] == true do
      Process.sleep(1000)
    end

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
    password = Encryption.decrypt(server.hashed_rcon_password)
    Rcon.connect(server.host, password, server.port)
  end
end
