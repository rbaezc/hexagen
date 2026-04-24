defmodule Mix.Tasks.Hexagen.Setup do
  use Mix.Task

  @shortdoc "Configures the current project for Hexagonal Architecture with HexaGen"

  @moduledoc """
  This task sets up the initial structure for Hexagonal Architecture.

  It will:
  1. Create the base directory structure:
     - `lib/app_name/domain`
     - `lib/app_name/application/ports`
     - `lib/app_name/application/use_cases`
     - `lib/app_name/infrastructure/persistence`
  2. Verify if it's a Phoenix project.
  """

  def run(_args) do
    app_name = Mix.Project.config()[:app]
    Mix.shell().info([:green, "* setting up hexagen for #{app_name}"])

    paths = [
      "lib/#{app_name}/domain",
      "lib/#{app_name}/application/ports",
      "lib/#{app_name}/application/use_cases",
      "lib/#{app_name}/infrastructure/persistence"
    ]

    for path <- paths do
      if not File.dir?(path) do
        File.mkdir_p!(path)
        Mix.shell().info([:green, "  creating ", :reset, path])
      end
    end

    Mix.shell().info([:green, "\nHexaGen established! 🚀"])
    
    Mix.shell().info([:yellow, "\nNext steps to enable testing:"])
    Mix.shell().info("1. Add {:mox, \"~> 1.0\", only: :test} to your mix.exs deps.")
    Mix.shell().info("2. Add 'import Mox' and your mock definitions to test/test_helper.exs.")
    
    Mix.shell().info([:yellow, "\nTo override adapters (Dependency Injection):"])
    Mix.shell().info("Add this to your config/config.exs:")
    Mix.shell().info("  config :#{app_name}, YourApp.ContextName, repository: YourApp.Infrastructure.Persistence.SpecificAdapter")

    Mix.shell().info([:cyan, "\nUse the generator:"])
    Mix.shell().info("mix hexagen.gen.context Accounts User users name:string")
  end
end
