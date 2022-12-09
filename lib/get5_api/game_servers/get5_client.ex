defmodule Get5Api.GameServers.Get5Client do
  alias Get5Api.GameServers.GameServer
  alias Get5Api.GameServers.Rcon

  @spec connect(%GameServer{}) :: tuple()
  def connect(server) do
    password = Encryption.decrypt(server.hashed_rcon_password)
    Rcon.connect(server.host, password, server.port)
  end

  def start_match(conn, match) do
    url = ""
    command = "get5_loadmatch_url \"\" \"Authorization\" \"Bearer #{match.api_key}\""
    Rcon.exec(conn, command)
  end

end
