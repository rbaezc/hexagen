defmodule Mix.Tasks.Hexagen.Gen.Html do
  use Mix.Task

  @shortdoc "Generates a hexagonal context and Phoenix HTML controller/templates"

  @moduledoc """
  Generates a hexagonal core and a Phoenix HTML layer.

      mix hexagen.gen.html Accounts User users name:string age:integer

  This task:
  1. Runs `mix hexagen.gen.context` to create the hexagonal structure.
  2. Runs `mix phx.gen.html --no-context` to create the web layer.
  """

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise "mix hexagen.gen.html can only be run inside an application directory"
    end

    # 1. Generate the Hexagonal Core
    Mix.shell().info([:blue, "Step 1: Generating Hexagonal Core..."])
    Mix.Tasks.Hexagen.Gen.Context.run(args)

    # 2. Generate the Web Layer
    # We pass --no-context because we've already generated our facade
    Mix.shell().info([:blue, "\nStep 2: Generating Phoenix Web Layer..."])
    Mix.Tasks.Phx.Gen.Html.run(args ++ ["--no-context"])
    
    Mix.shell().info([:green, "\nHexagonal HTML resource ready! 🚀"])
  end
end
