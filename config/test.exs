use Mix.Config

config :accountable, :ecto_repo, Accountable.TestRepo

config :accountable, Accountable.TestRepo,
  url: System.get_env("POSTGRES_URL"),
  pool: Ecto.Adapters.SQL.Sandbox

config :accountable, ecto_repos: [Accountable.TestRepo]

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :accountable, Accountable.Guardian,
  issuer: "accountable",
  secret_key: "secret"
