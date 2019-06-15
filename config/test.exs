use Mix.Config

config :accountable, :ecto_repo, Accountable.TestRepo

config :accountable, Accountable.TestRepo,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: System.get_env("POSTGRES_DB"),
  hostname: System.get_env("POSTGRES_HOST"),
  pool: Ecto.Adapters.SQL.Sandbox

config :accountable, ecto_repos: [Accountable.TestRepo]

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :accountable, Accountable.Guardian,
  issuer: "accountable",
  secret_key: "secret"
