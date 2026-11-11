defmodule Mix.Tasks.Hexagen.Codegraph do
  use Mix.Task

  @shortdoc "Runs static analysis and persists module dependencies to a local SQLite database"

  @moduledoc """
  This task parses the current project's code structure and indexes all module dependencies in SQLite.

  ## Options

    * `-i`, `--init` - Scans the project, calculates MD5 hashes, extracts dependencies, and indexes them in `codegraph.db`.
  """

  alias Hexagen.CodeGraph.Indexer

  @spec run([String.t()]) :: :ok
  def run(args) do
    # Option parsing
    {opts, _, _} = OptionParser.parse(args, aliases: [i: :init], switches: [init: :boolean])

    if opts[:init] do
      Mix.shell().info([:green, "* Initializing CodeGraph Static Analysis..."])

      project_path = File.cwd!()
      db_path = Path.join(project_path, "codegraph.db")

      Mix.shell().info([:cyan, "  Scanning directory: ", :reset, project_path])
      Mix.shell().info([:cyan, "  Target database: ", :reset, db_path])

      # Ensure exqlite and ecto_sqlite3 driver dependencies are fully booted
      {:ok, _} = Application.ensure_all_started(:ecto_sqlite3)

      case Indexer.index_project(project_path, db_path) do
        {:ok, stats} ->
          Mix.shell().info([:green, "\nCodeGraph Static Analysis Completed! 🚀"])
          Mix.shell().info([:green, "  Modules indexed: ", :reset, "#{stats.modules_indexed}"])
          Mix.shell().info([:green, "  External modules registered: ", :reset, "#{stats.external_modules_registered}"])
          Mix.shell().info([:green, "  Dependencies indexed: ", :reset, "#{stats.dependencies_indexed}"])
          Mix.shell().info([:green, "  Database file written to: ", :reset, db_path])

        {:error, reason} ->
          Mix.shell().error("  Failed to perform CodeGraph indexing: #{inspect(reason)}")
      end
    else
      Mix.shell().info([:yellow, "Usage: mix hexagen.codegraph -i | --init"])
    end
  end
end
