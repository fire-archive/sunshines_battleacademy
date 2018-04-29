# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sunshines_battleacademy, ecto_repos: [SunshinesBattleacademy.Repo]

# Configures the endpoint
config :sunshines_battleacademy, SunshinesBattleacademy.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GTB+p5O2Qwmum6SHKGEz5dIK24YnqANtriL0EGGpjKEncEFvpS6w3qcDAD9pxkZf",
  render_errors: [view: SunshinesBattleacademy.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SunshinesBattleacademy.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# config :pooler, pools:
#  [[
#      name: :riakremote1,
#      group: :riak,
#      max_count: 15,
#      init_count: 2,
#      start_mfa: { Riak.Connection, :start_link, ['172.17.0.2', 8087] }
#    ] 
#  ]

config :sunshines_battleacademy, SunshinesBattleacademy.Cache,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600

config :sunshines_battleacademy, SunshinesBattleacademy.SpatialCache,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600

config :sunshines_battleacademy, SunshinesBattleacademy.BlockCache,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
