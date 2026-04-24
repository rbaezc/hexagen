defmodule Mix.Tasks.Hexagen.Gen.ContextTest do
  use ExUnit.Case

  alias Mix.Tasks.Hexagen.Gen.Context

  setup do
    # Cleanup
    File.rm_rf!("lib/hexagen")
    File.rm_rf!("priv/repo")
    File.rm_rf!("test/hexagen")
    :ok
  end

  test "generates all hexagonal layers and tests" do
    # We use --no-migration and --no-context (for phx delegation)
    # Actually, we WANT it to run our logic.
    Context.run(["Accounts", "User", "users", "name:string", "--no-migration"])
    
    # 1. Domain
    assert File.exists?("lib/hexagen/domain/entities/user.ex")
    
    # 2. Application
    assert File.exists?("lib/hexagen/application/ports/user_repository.ex")
    assert File.exists?("lib/hexagen/application/use_cases/list_users.ex")
    assert File.exists?("lib/hexagen/application/use_cases/get_user.ex")
    assert File.exists?("lib/hexagen/application/use_cases/create_user.ex")
    
    # 3. Infrastructure
    assert File.exists?("lib/hexagen/infrastructure/persistence/ecto_user_repository.ex")
    
    # 4. Facade
    assert File.exists?("lib/hexagen/accounts.ex")
    content = File.read!("lib/hexagen/accounts.ex")
    assert content =~ "@repo Application.compile_env"

    # 5. Tests
    assert File.exists?("test/hexagen/application/use_cases/create_user_test.exs")
    assert File.exists?("test/hexagen/infrastructure/persistence/ecto_user_repository_test.exs")
    
    # Cleanup
    File.rm_rf!("lib/hexagen")
    File.rm_rf!("priv/repo")
    File.rm_rf!("test/hexagen")
  end
end
