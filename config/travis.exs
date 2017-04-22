use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sunshines_battleacademy, SunshinesBattleacademy.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :sunshines_battleacademy, SunshinesBattleacademy.Repo,
  adapter: Sqlite.Ecto2,
  database: "sunshines_battleacademy_test.sqlite3",
  pool: Ecto.Adapters.SQL.Sandbox
 
