defmodule Get5Api.GameServers.Get5Client do
  alias Get5Api.GameServers.GameServer
  alias Get5Api.GameServers.Rcon
  alias Get5Api.Encryption
  alias Get5ApiWeb.Endpoint

  def start_match(match) do
    # TODO: Find way to get correct url or ip (not "localhost" as Endpoint.url gives locally)
    url = "#{Endpoint.url}/matches/#{match.id}/match_config"
    command = "get5_loadmatch_url \"#{url}\" \"Authorization\" \"Bearer #{match.api_key}\""
    {:ok,conn} = connect(match.game_server)
    Rcon.exec(conn, command) # TODO: Check for success and error handling
  end

  def end_match(match) do
    {:ok, conn} = connect(match.game_server)
    Rcon.exec(conn, "get5_endmatch") # TODO: Error handling
  end

  @spec connect(%GameServer{}) :: tuple()
  defp connect(server) do
    password = Encryption.decrypt(server.hashed_rcon_password)
    Rcon.connect(server.host, password, server.port)
  end

end
