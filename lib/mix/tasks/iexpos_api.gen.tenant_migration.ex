defmodule Mix.Tasks.IexposApi.Gen.TenantMigration do
  use Mix.Task

  import Macro, only: [camelize: 1, underscore: 1]
  import Mix.Generator
  import Mix.Ecto

  @migrations_folder "tenant_migrations"

  @shortdoc "Generate tenant migration for the repo"

  @moduledoc """
  Generates a tenant migration.

  The repository must be set under `:ecto_repos` in the
  current app configuration or given via the `-r` option.

  ## Examples

      mix iexpos.gen.tenant_migration add_posts_table
      mix iexpos.gen.tenant_migration add_posts_table -r Custom.Repo

  By default, the migration will be generated to the
  "priv/YOUR_REPO/migrations" directory of the current application
  but it can be configured to be any subdirectory of `priv` by
  specifying the `:priv` key under the repository configuration.

  This generator will automatically open the generated file if
  you have `ECTO_EDITOR` set in your environment variable.

  ## Command line options

    * `-r`, `--repo` - the repo to generate migration for

  """

  @switches [change: :string]

  @doc false
  def run(args) do
    no_umbrella!("iexpos_api.gen.tenant_migration")
    repos = parse_repo(args)

    Enum.each(repos, fn repo ->
      with {opts, [name], _} <- OptionParser.parse(args, switches: @switches) do
        ensure_repo(repo, args)

        path =
          Path.relative_to(
            tenant_migrations_path(repo),
            Mix.Project.app_path()
          )

        file =
          Path.join(
            path,
            "#{timestamp()}_#{underscore(name)}.exs"
          )

        create_directory(path)

        assigns = [
          mod: Module.concat([repo, Migrations, camelize(name)]),
          change: opts[:change]
        ]

        create_file(file, migration_template(assigns))

        if open?(file) and
          Mix.shell().yes?("Do you want to run this migration?") do
            Mix.Task.run("ecto.migrate", [repo])
          end


      else
        {_, _, _} ->
          Mix.raise(
            "expected iexpos_api.gen.migration to receive the migration file name, " <>
              "got: #{inspect(Enum.join(args, " "))}"
          )
      end
    end)
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: <<?0, ?0 + i>>
  defp pad(i), do: to_string(i)

  defp tenant_migrations_path(repo) do
    priv_path_for(repo, @migrations_folder)
  end

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp priv_path_for(repo, filename) do
    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    Path.join([priv_dir(:iexpos_api), repo_underscore, filename])
  end

  embed_template(:migration, """
    ## Note
    ## This file is only for tenant migration by schema_path
    ##
    defmodule <%= inspect @mod %> do
      use Ecto.Migration

      def change do
        <%= @change %>
      end
    end
  """)

end
