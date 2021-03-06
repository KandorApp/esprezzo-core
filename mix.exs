defmodule EsprezzoCore.Mixfile do
  use Mix.Project

  def project do
    [
      app: :esprezzo_core,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:rustler, :phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
	    rustler_crates: rustler_crates()
    ]
  end

  def rustler_crates do
    [
      peernet_protocols: [
        path: "native/peernet_protocols",
        mode: (if Mix.env == :prod, do: :release, else: :debug)
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {EsprezzoCore.Application, []},
      extra_applications: [:logger, :runtime_tools, :edeliver, :corsica],
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:rustler, "~> 0.10.1"},
      {:edeliver, "~> 1.4.4"},
      {:distillery, "~> 1.5", runtime: false},
      {:secure_random, "~> 0.5"},
      {:mnemonic, "~> 0.2.0"},
      {:apex, "~>1.2.0"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:corsica, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.drop", "ecto.create", "ecto.migrate", "test --trace"],
      "esp.start": ["phx.server"]
    ]
  end
end
