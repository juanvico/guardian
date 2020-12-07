# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :guardian,
  ecto_repos: [Guardian.Repo]

# Configures the endpoint
config :guardian, GuardianWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YTuQJ1TfuZgphFpXg5oX4D3R/Qs9CrV0Q/iHLkcF9v6Wos8v1NpULSvcFBBKkoBQ",
  render_errors: [view: GuardianWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Guardian.PubSub,
  live_view: [signing_salt: "2+RuRcXe"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Torch
config :torch,
  otp_app: :guardian,
  template_format: "eex"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
