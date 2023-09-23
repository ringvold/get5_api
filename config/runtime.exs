import Config

# Get correct IP for testing locally. You might need to modify this for your machine.
# My machine has the local network IP that my test csgo server can reach at
# index 1 in the list.
if System.get_env("GET5API_IP_FIX") == "true" do
  IO.puts("Using IP fix for local testing")
  {:ok, [{ip, _, _}, _]} = :inet.getif()
  {a, b, c, d} = ip
  ip = "#{a}.#{b}.#{c}.#{d}"
  IO.puts("IP address: #{ip}")
  config :get5_api, Get5ApiWeb.Endpoint, url: [host: ip]
end

# Override IP used by phoenix. Usefull for testing get5 event/callbacks over
# tailscale.
if System.get_env("GET5API_IP") do
  IO.puts("Using fixed IP addess from GET5API_IP env")
  ip = System.get_env("GET5API_IP")
  IO.puts("IP address: #{ip}")
  config :get5_api, Get5ApiWeb.Endpoint, url: [host: ip]
end

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  app_name =
    System.get_env("FLY_APP_NAME") ||
      raise "FLY_APP_NAME not available"

  config :get5_api, Get5ApiWeb.Endpoint,
    server: true,
    url: [host: "#{app_name}.fly.dev", port: 80],
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      # IMPORTANT: support IPv6 addresses
      transport_options: [socket_opts: [:inet6]]
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

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to your endpoint configuration:
#
#     config :my_app, MyAppWeb.Endpoint,
#       https: [
#         ...,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :my_app, MyAppWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.
