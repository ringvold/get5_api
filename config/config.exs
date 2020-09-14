# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :get5_api,
  ecto_repos: [Get5Api.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :get5_api, Get5ApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6wWkY5MdPncUEKUfSNe93SoctprfRnxoUwAc7qQzixk5YPUgbZebN+QDAfAWjekN",
  render_errors: [view: Get5ApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Get5Api.PubSub,
  live_view: [signing_salt: "27S45xNG"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
