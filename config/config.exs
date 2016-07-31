# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ex_tv_movie_scraper,
  ecto_repos: [ExTvMovieScraper.Repo]

# Configures the endpoint
config :ex_tv_movie_scraper, ExTvMovieScraper.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5+tiNpGBBtfHgyojQ9dMcSGnCZ1eg3bWsuG8nWXV+0VfXNY8n0+ohDn8AWprNJGp",
  render_errors: [view: ExTvMovieScraper.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ExTvMovieScraper.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
