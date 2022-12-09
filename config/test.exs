import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :get5_api, Get5Api.Repo,
  username: "postgres",
  password: "postgres",
  database: "get5_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :get5_api, Get5ApiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning


System.put_env("SECRET_KEY_BASE", "+kftAeXQN4AFyY0ROBKkx62sd1AxJxk37jvAp8iN0MFm3cs13rXbEX2jtCS0P2xf")
