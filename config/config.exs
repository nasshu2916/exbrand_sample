# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :exbrand_sample,
  ecto_repos: [ExbrandSample.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configure the endpoint
config :exbrand_sample, ExbrandSampleWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  pubsub_server: ExbrandSample.PubSub,
  render_errors: [
    formats: [html: ExbrandSampleWeb.ErrorHTML, json: ExbrandSampleWeb.ErrorJSON],
    layout: false
  ]

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
