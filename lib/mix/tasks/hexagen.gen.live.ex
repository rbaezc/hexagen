defmodule Mix.Tasks.Hexagen.Gen.Live do
  use Mix.Task

  @shortdoc "Generates a hexagonal context and Phoenix LiveView"

  @moduledoc """
  Generates a hexagonal core and a Phoenix LiveView layer.

      mix hexagen.gen.live Accounts User users name:string age:integer
  """

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise "mix hexagen.gen.live can only be run inside an application directory"
    end

    Mix.shell().info([:blue, "Step 1: Generating Hexagonal Core..."])
    Mix.Tasks.Hexagen.Gen.Context.run(args)

    Mix.shell().info([:blue, "\nStep 2: Generating Phoenix LiveView Layer..."])
    Mix.Tasks.Phx.Gen.Live.run(args ++ ["--no-context"])
    
    Mix.shell().info([:green, "\nHexagonal LiveView ready! 🚀"])
  end
end
