defmodule Get5Api.GameServers.Get5Client do
  alias Get5Api.GameServers.GameServer
  alias Get5Api.GameServers.Rcon

  @spec connect(%GameServer{}) :: tuple()
  def connect(server) do
    password = Encryption.decrypt(server.hashed_rcon_password)
    Rcon.connect(server.host, password, server.port)
  end

  def start_match(conn, match) do
    url = Get5Api.Endpoint.url <> "/matches/#{match.id}/match_config"
    command = "get5_loadmatch_url \"#{url}\" \"Authorization\" \"Bearer #{match.api_key}\""
    Rcon.exec(conn, command)
  end

end
