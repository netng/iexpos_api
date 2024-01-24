defmodule IexposApi.V1.Helper.TenantActions do
  @moduledoc """
  Utilities that help with managing tenant's prefixed databases.
  """

  alias Ecto.Migration.SchemaMigration

  import Ecto.Query, only: [from: 2]


  @migrations_folder "tenant_migrations"
  @schema_prefix "tenant_"

  def get_prefix_for_tenant(tenant) do
    @schema_prefix <> String.downcase(tenant)
  end

  def create_tenant_database_schema(tenant) do
    prefix = get_prefix_for_tenant(tenant)

    config =
      Application.get_env(:iexpos_api, IexposApi.Repo)
      |> Keyword.put(:name, nil)
      |> Keyword.put(:pool_size, 2)
      |> Keyword.put(:migration_default_prefix, prefix)
      |> Keyword.put(:prefix, prefix)
      |> Keyword.delete(:pool)

    {:ok, pid} = IexposApi.Repo.start_link(config)
    IexposApi.Repo.put_dynamic_repo(pid)

    query = """
    CREATE SCHEMA "#{prefix}"
    """

    IexposApi.Repo.query(query)
    SchemaMigration.ensure_schema_migrations_table!(IexposApi.Repo, config, [])

    migrate_repo(
      prefix: prefix,
      dynamic_repo: pid
    )

    IexposApi.Repo.stop(1000)
    IexposApi.Repo.put_dynamic_repo(IexposApi.Repo)
    {:ok, tenant}
  end

  def tenant_migrations_path(repo) do
    priv_path_for(repo, @migrations_folder)
  end

  def migrate_repo(options \\ []) do
    options = Keyword.put(options, :all, true)
    repo = IexposApi.Repo

    Ecto.Migrator.run(
      repo,
      tenant_migrations_path(repo),
      :up,
      options
    )
  end

  def list_tenants(repo) do
    query =
      from(
        schemata in "schemata",
        select: schemata.schema_name,
        where: like(schemata.schema_name, ^"#{@schema_prefix}%")
      )

      repo.all(query, prefix: "information_schema")
  end



  def migrate() do
    config =
      Application.get_env(:iexpos_api, IexposApi.Repo)
      |> Keyword.put(:name, nil)
      |> Keyword.put(:pool_size, 2)
      # |> Keyword.put(:migration_default_prefix, "public")
      # |> Keyword.put(:prefix, "public")
      |> Keyword.delete(:pool)

    {:ok, pid} = IexposApi.Repo.start_link(config)
    IexposApi.Repo.put_dynamic_repo(pid)

    tenants = list_tenants(IexposApi.Repo)

    Enum.each(tenants, fn tenant ->
      migrate_repo(prefix: tenant, dynamic_repo: pid)
      Mix.shell().info("#{tenant} migrated")
    end)

    Mix.shell().info("Migrations completed")

    IexposApi.Repo.stop(1000)
    IexposApi.Repo.put_dynamic_repo(IexposApi.Repo)
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
end
