defmodule Hexagen.MixProject do
  use Mix.Project

  def project do
    [
      app: :hexagen,
      version: "0.1.0",
      elixir: "~> 1.19",
      description: "Standardized Hexagonal Architecture Scaffolding for Phoenix Applications",
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
      source_url: "https://github.com/vortex-solutions/hexagen"
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/vortex-solutions/hexagen"}
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
      {:excoveralls, "~> 0.18", only: :test}
    ]
  end
end
