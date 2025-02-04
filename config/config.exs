# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hodl,
  ecto_repos: [Hodl.Repo]

config :hodl, development: System.get_env("DEVELOPMENT")

config :hodl, message_bird_api: System.get_env("MESSAGE_BIRD_API")

# Configures the endpoint
config :hodl, HodlWeb.Endpoint,
  url: [host: "localhost", port: 4000],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: HodlWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Hodl.PubSub,
  live_view: [signing_salt: "iVBXoGuJ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :hodl, :pow,
  user: Hodl.Users.User,
  repo: Hodl.Repo,
  web_module: HodlWeb,
  extensions: [PowResetPassword, PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: HodlWeb.Pow.Mailer,
  web_mailer_module: HodlWeb


config :pow, HodlWeb.Pow.Mailer,
  adapter: Swoosh.Adapters.Postmark,
  api_key: System.get_env("POSTMARK_KEY")

config :hodl, Oban,
repo: Hodl.Repo,
plugins: [Oban.Plugins.Pruner,Oban.Plugins.Stager, {Oban.Plugins.Cron,
crontab: [
  {System.get_env("MINUTE_WORKER_FREQUENCY"), Hodl.MinuteWorker},
]}],
queues: [repetitive: [limit: 3], emails: [limit: 3]]


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
