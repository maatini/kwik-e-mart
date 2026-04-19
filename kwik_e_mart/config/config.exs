# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

signing_salt = "ElJaGz4v"

config :kwik_e_mart,
       KwikEMartWeb.KwikEndpoint,
       url: [host: "localhost"],
       adapter: Bandit.PhoenixAdapter,
       render_errors: [
         formats: [html: Beacon.Web.ErrorHTML],
         layout: false
       ],
       pubsub_server: KwikEMart.PubSub,
       live_view: [signing_salt: signing_salt]

config :kwik_e_mart,
       KwikEMartWeb.ProxyEndpoint,
       adapter: Bandit.PhoenixAdapter,
       pubsub_server: KwikEMart.PubSub,
       render_errors: [
         formats: [html: Beacon.Web.ErrorHTML],
         layout: false
       ],
       live_view: [signing_salt: signing_salt]

config :kwik_e_mart,
  ecto_repos: [KwikEMart.Repo],
  generators: [timestamp_type: :utc_datetime],
  session_options: [
    store: :cookie,
    key: "_kwik_e_mart_key",
    signing_salt: signing_salt,
    same_site: "Lax"
  ]

# Configures the endpoint
config :kwik_e_mart, KwikEMartWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: KwikEMartWeb.ErrorHTML, json: KwikEMartWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: KwikEMart.PubSub,
  live_view: [signing_salt: signing_salt]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :kwik_e_mart, KwikEMart.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  kwik_e_mart: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  kwik_e_mart: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
