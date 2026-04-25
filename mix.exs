defmodule Hexagen.MixProject do
  use Mix.Project

  def project do
    [
      app: :hexagen,
      version: "0.1.1",
      elixir: "~> 1.15",
      description:
        "The Architecture Guardian for Phoenix. A strict Hexagonal Architecture scaffolding tool.",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      package: package(),
      deps: deps(),
      docs: [
        main: "readme",
        extras: ["README.md", "CHANGELOG.md"],
        groups_for_modules: [
          "Domain Layer": [~r/Hexagen\.Domain/],
          "Application Layer": [~r/Hexagen\.Application/],
          "Infrastructure Layer": [~r/Hexagen\.Infrastructure/],
          "Mix Tasks": [~r/Mix\.Tasks\.Hexagen/]
        ]
      ],
      source_url: "https://github.com/rbaezc/hexagen"
    ]
  end

  defp package do
    [
      maintainers: ["Raul Baez Camarillo"],
      files: ["lib", "priv", "mix.exs", "README.md", "CHANGELOG.md", "LICENSE"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/rbaezc/hexagen"}
    ]
  end

  def cli do
    [
      preferred_envs: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Hexagen.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.7"},
      {:phoenix_ecto, "~> 4.4"},
      {:jason, "~> 1.2"},
      {:excoveralls, "~> 0.18", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
