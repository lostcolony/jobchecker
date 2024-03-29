defmodule Jobchecker.MixProject do
  use Mix.Project

  def project do
    [
      app: :jobchecker,
      version: "0.1.0",
      elixir: "~> 1.13",
      escript: [main_module: Jobchecker.Main],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: ["lib","jobs"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:floki, "~> 0.33.0"},
      {:html5ever, "~> 0.13.0"},
      {:json, "~> 1.4"},
      {:elixpath, "~> 0.1.0"},
      {:memento, "~> 0.3.2"},
      {:gen_smtp, "~> 1.2"},
      {:rustler, ">= 0.0.0", optional: true}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
