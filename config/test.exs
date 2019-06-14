use Mix.Config

config :accountable, Accountable.TestRepo,
  username: "postgres",
  password: "postgres",
  database: "accountable_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :accountable, ecto_repos: [Accountable.TestRepo]

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :accountable, Accountable.Guardian,
  issuer: "accountable",
  secret_key: "secret"
