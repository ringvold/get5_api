import Config
require Logger

# Get correct IP for testing locally. You might need to modify this for your machine.
# My machine has the local network IP that my test csgo server can reach at
# index 1 in the list.
if System.get_env("GET5API_IP_FIX") == "true" do
  Logger.debug("Using IP fix for local testing")
  {:ok, [{ip, _, _}, _]} = :inet.getif()
  {a, b, c, d} = ip
  ip = "#{a}.#{b}.#{c}.#{d}"
  Logger.debug("IP address: #{ip}")
  config :get5_api, Get5ApiWeb.Endpoint, url: [host: ip]
end

# Override IP used by phoenix. Usefull for testing get5 event/callbacks over
# tailscale.
if System.get_env("GET5API_IP") do
  Logger.debug("Using fixed host/IP addess from GET5API_IP env")
  host = System.get_env("GET5API_IP")

  case String.split(host, ":") do
    [host, port] ->
      Logger.debug("Host: #{host}, port: #{port}")
      config :get5_api, Get5ApiWeb.Endpoint, url: [host: host, port: port]

    [host] ->
      Logger.debug("Host: #{host}")
      config :get5_api, Get5ApiWeb.Endpoint, url: [host: host]
  end
end

if System.get_env("PHX_SERVER") do
  config :get5_api, Get5ApiWeb.Endpoint, server: true
end

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :get5_api, Get5ApiWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  config :get5_api,
    env: :prod

  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :get5_api, Get5Api.Repo,
    url: database_url,
    # IMPORTANT: Or it won't find the DB server
    socket_options: [:inet6],
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
end
