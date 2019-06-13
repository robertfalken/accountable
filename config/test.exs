use Mix.Config

config :accountable, Accountable.TestRepo,
  username: "postgres",
  password: "postgres",
  database: "accountable_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :accountable, ecto_repos: [Accountable.TestRepo]

