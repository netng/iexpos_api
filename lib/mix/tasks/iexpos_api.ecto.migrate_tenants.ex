defmodule Mix.Tasks.IexposApi.Ecto.MigrateTenants do
  use Mix.Task

  alias IexposApi.V1.Helper.TenantActions

  @shortdoc "Runs repository migrations only for tenants"

  @doc false
  def run(_args) do
    Code.compiler_options(ignore_module_conflict: true)
    {:ok, _} = Application.ensure_all_started(:iexpos_api)

    tenants = TenantActions.list_tenants(IexposApi.Repo)
    Enum.each(tenants, &migrate_tenant/1)
    Mix.shell().info("Migrations completed")
  end

  defp migrate_tenant(tenant) do
    TenantActions.migrate_repo(prefix: tenant)
    Mix.shell().info("#{tenant} migrated")
  end


end
