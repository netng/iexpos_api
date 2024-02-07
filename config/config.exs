# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :iexpos_api,
  ecto_repos: [IexposApi.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :iexpos_api, IexposApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: IexposApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: IexposApi.PubSub,
  live_view: [signing_salt: "nEHRMZKY"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :iexpos_api, IexposApiWeb.Auth.Guardian,
  issuer: "iexpos_api",
  secret_key: "fqvqYdMX/7VSbif4CLS6sRRILU29eIse8sYF6YV4DJXgIa6udB3T8eYNUpmqMIgp"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
