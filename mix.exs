defmodule Hodl.MixProject do
  use Mix.Project

  def project do
    [
      app: :hodl,
      version: "0.1.0",
      elixir: "~> 1.11.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Hodl.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.7"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.5.0"},
      {:pow, "~> 1.0.24"},
      {:ecto_shortuuid, "~> 0.1.3"},
      {:httpoison, "~> 1.8"},
      {:oban, "~> 2.6"},
      {:ecto_autoslug_field, "~> 2.0"},
      {:quantum, "~> 3.3"},
      {:swoosh, "~> 1.3.11"},
      {:cors_plug, "~> 2.0"},
      {:phoenix_swoosh, "~> 0.3"},
      {:decimal, "~> 2.0"},
      {:bodyguard, "~> 2.4"},
      {:tzdata, "~> 1.1"},
      {:ex_phone_number, "~> 0.2"},
      {:mojito, "~> 0.7.7"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
