import Config

# Beacon: use :testing mode so it doesn't hot-load resources or broadcast events during tests
config :beacon,
  kwik: [
    site: :kwik,
    repo: KwikEMart.Repo,
    endpoint: KwikEMartWeb.KwikEndpoint,
    router: KwikEMartWeb.Router,
    mode: :testing
  ]

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :kwik_e_mart, KwikEMart.Repo,
  url:
    System.get_env(
      "TEST_DATABASE_URL",
      "postgres://postgres:postgres@localhost:5433/kwik_e_mart_test"
    ),
  database: "kwik_e_mart_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kwik_e_mart, KwikEMartWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "YFqZHBMOzCRhTFxW7w7MtYZcq73hzun7I6nzpdcR8saz0vN/gAleJ+T4kCu1tprm",
  server: false

# In test we don't send emails
config :kwik_e_mart, KwikEMart.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Enable Phoenix.Ecto.SQL.Sandbox plug for LiveView tests
config :kwik_e_mart, sql_sandbox: true

# Cache deaktivieren – verhindert stale-Data zwischen Tests
config :kwik_e_mart, :cache_enabled, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
