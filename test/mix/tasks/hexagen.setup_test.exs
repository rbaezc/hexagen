defmodule Mix.Tasks.Hexagen.SetupTest do
  use ExUnit.Case

  alias Mix.Tasks.Hexagen.Setup

  setup do
    tmp_path = Path.expand("../../../tmp/hexagen_setup", __DIR__)
    File.rm_rf!(tmp_path)
    File.mkdir_p!(tmp_path)
    
    # Mocking app name for the test
    # We'll just check if it creates the folders based on the current context if possible
    # but since it's a Mix task, it uses Mix.Project.config()
    
    :ok
  end

  # We use a trick to test Mix tasks in isolation
  test "creates the hexagonal directory structure" do
    app_name = "test_app"
    paths = [
      "lib/#{app_name}/domain",
      "lib/#{app_name}/application/ports",
      "lib/#{app_name}/application/use_cases",
      "lib/#{app_name}/infrastructure/persistence"
    ]

    # Clean up before
    for path <- paths, do: File.rm_rf!(path)

    # We need to mock Mix.Project.config()[:app]
    # But since it's hard to mock Mix during runtime, 
    # and the task uses Mix.Project.config()[:app], 
    # it will pick up :hexagen when running tests for this library.

    Setup.run([])

    assert File.dir?("lib/hexagen/domain")
    assert File.dir?("lib/hexagen/application/ports")
    assert File.dir?("lib/hexagen/application/use_cases")
    assert File.dir?("lib/hexagen/infrastructure/persistence")
    
    # Cleanup
    File.rm_rf!("lib/hexagen")
  end
end
