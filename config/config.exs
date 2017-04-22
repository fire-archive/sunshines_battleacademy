# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ifires_sunshine_battleacademy,
  ecto_repos: [IfiresSunshineBattleacademy.Repo]

# Configures the endpoint
config :ifires_sunshine_battleacademy, IfiresSunshineBattleacademy.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GTB+p5O2Qwmum6SHKGEz5dIK24YnqANtriL0EGGpjKEncEFvpS6w3qcDAD9pxkZf",
  render_errors: [view: IfiresSunshineBattleacademy.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: IfiresSunshineBattleacademy.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
