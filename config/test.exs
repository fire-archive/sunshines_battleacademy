use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ifires_sunshine_battleacademy, IfiresSunshineBattleacademy.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ifires_sunshine_battleacademy, IfiresSunshineBattleacademy.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "ifires_sunshine_battleacademy_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
