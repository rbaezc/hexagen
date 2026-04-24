defmodule Mix.Tasks.Hexagen.Gen.Context do
  use Mix.Task

  @shortdoc "Generates a hexagonal context for a resource"

  @moduledoc """
  Generates a hexagonal structure: Domain, Application (Ports/Use Cases), and Infrastructure (Adapters).

      mix hexagen.gen.context Accounts User users name:string age:integer

  The first argument is the context name (e.g. Accounts).
  The second argument is the schema name (e.g. User).
  The third argument is the plural name (e.g. users).
  The remaining arguments are the schema fields.
  """

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise "mix hexagen.gen.context can only be run inside an application directory"
    end

    # We reuse Phoenix's argument parsing
    # This returns {context, schema}
    {context, schema} = Mix.Tasks.Phx.Gen.Context.build(args)
    
    app_name = Mix.Project.config()[:app]
    
    Mix.shell().info([:green, "* generating hexagonal files for #{schema.module}"])

    # Use Module.split to get clean names without "Elixir." prefix
    base_module = 
      case Mix.Project.config()[:module] do
        nil -> Phoenix.Naming.camelize(to_string(app_name))
        module -> module |> Module.split() |> List.last()
      end

    schema_alias = schema.alias |> to_string() |> Module.split() |> List.last()
    context_name = context.module |> Module.split() |> List.last()

    assigns = [
      schema: schema, 
      app_name: app_name,
      context: context_name,
      base_module: base_module,
      schema_alias: schema_alias,
      context_name: context_name
    ]

    Mix.shell().info([:cyan, "* base_module: #{base_module}, schema_alias: #{schema_alias}, context: #{context_name}"])

    # 1. Domain Entity
    copy_template(
      "priv/templates/hexagen.gen.context/domain_entity.ex.eex",
      "lib/#{app_name}/domain/entities/#{schema.singular}.ex",
      assigns
    )

    # 2. Port (Behaviour)
    copy_template(
      "priv/templates/hexagen.gen.context/port.ex.eex",
      "lib/#{app_name}/application/ports/#{schema.singular}_repository.ex",
      assigns
    )

    # 3. Adapter (Ecto)
    copy_template(
      "priv/templates/hexagen.gen.context/adapter.ex.eex",
      "lib/#{app_name}/infrastructure/persistence/ecto_#{schema.singular}_repository.ex",
      assigns
    )

    # 4. Use Cases
    copy_template(
      "priv/templates/hexagen.gen.context/use_cases/list.ex.eex",
      "lib/#{app_name}/application/use_cases/list_#{schema.plural}.ex",
      assigns
    )

    copy_template(
      "priv/templates/hexagen.gen.context/use_cases/get.ex.eex",
      "lib/#{app_name}/application/use_cases/get_#{schema.singular}.ex",
      assigns
    )

    copy_template(
      "priv/templates/hexagen.gen.context/use_cases/create.ex.eex",
      "lib/#{app_name}/application/use_cases/create_#{schema.singular}.ex",
      assigns
    )

    # 5. Context Facade (Overwriting standard Phoenix context)
    copy_template(
      "priv/templates/hexagen.gen.context/facade.ex.eex",
      context.file,
      assigns
    )

    # 6. Tests
    copy_template(
      "priv/templates/hexagen.gen.context/tests/use_case_test.exs.eex",
      "test/#{app_name}/application/use_cases/create_#{schema.singular}_test.exs",
      assigns
    )

    copy_template(
      "priv/templates/hexagen.gen.context/tests/adapter_test.exs.eex",
      "test/#{app_name}/infrastructure/persistence/ecto_#{schema.singular}_repository_test.exs",
      assigns
    )
    
    # 7. Standard Phoenix Schema and Migration (Keep compatibility)
    # We delegate to phx.gen.schema to get the Ecto Schema and Migration
    # We remove the first argument (Context) because gen.schema doesn't expect it
    Mix.Tasks.Phx.Gen.Schema.run(tl(args))

    # 8. Automate Mox configuration
    inject_mox_mock(base_module, schema_alias)
  end

  defp inject_mox_mock(base_module, schema_alias) do
    test_helper = "test/test_helper.exs"
    mock_name = "#{base_module}.Application.Ports.#{schema_alias}RepositoryMock"
    port_name = "#{base_module}.Application.Ports.#{schema_alias}Repository"
    
    if File.exists?(test_helper) do
      content = File.read!(test_helper)
      unless String.contains?(content, mock_name) do
        mock_line = "\nMox.defmock(#{mock_name}, for: #{port_name})"
        File.write!(test_helper, content <> mock_line)
        Mix.shell().info([:green, "* injecting ", :reset, mock_name, " into test_helper.exs"])
      end
    end
  end

  defp copy_template(source, target, assigns) do
    content = EEx.eval_file(source, assigns)
    File.mkdir_p!(Path.dirname(target))
    File.write!(target, content)
    Mix.shell().info([:green, "  creating ", :reset, target])
  end
end
