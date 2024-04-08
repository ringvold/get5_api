# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :get5_api,
  ecto_repos: [Get5Api.Repo],
  env: config_env(),
  encryption_key: "MaVRItF5pUXwisQld88PmNLIhCUsxNkuyftzqZh2AwToCGLdnwfeWvZbKq0gH3j1"

# Configures the endpoint
config :get5_api, Get5ApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  secret_key_base: "MaVRItF5pUXwisQld88PmNLIhCUsxNkuyftzqZh2AwToCGLdnwfeWvZbKq0gH3j1",
  render_errors: [
    formats: [html: Get5ApiWeb.ErrorHTML, json: Get5ApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Get5Api.PubSub,
  live_view: [signing_salt: "MfwQGPQ2"]

config :get5_api, Get5Api.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

config :esbuild,
  version: "0.18.17",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.3",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Uberauth
# config :ueberauth, Ueberauth,
#   providers: [
#     steam: {Ueberauth.Strategy.Steam, []}
#   ]

# Uberauth Steam strategy
# config :ueberauth, Ueberauth.Strategy.Steam, api_key: System.get_env("STEAM_API_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
