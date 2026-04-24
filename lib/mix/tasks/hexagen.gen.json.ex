defmodule Mix.Tasks.Hexagen.Gen.Json do
  use Mix.Task

  @shortdoc "Generates a hexagonal context and Phoenix JSON controller/views"

  @moduledoc """
  Generates a hexagonal core and a Phoenix JSON API layer.

      mix hexagen.gen.json Accounts User users name:string age:integer
  """

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise "mix hexagen.gen.json can only be run inside an application directory"
    end

    Mix.shell().info([:blue, "Step 1: Generating Hexagonal Core..."])
    Mix.Tasks.Hexagen.Gen.Context.run(args)

    Mix.shell().info([:blue, "\nStep 2: Generating Phoenix JSON API Layer..."])
    Mix.Tasks.Phx.Gen.Json.run(args ++ ["--no-context"])
    
    Mix.shell().info([:green, "\nHexagonal JSON API ready! 🚀"])
  end
end
