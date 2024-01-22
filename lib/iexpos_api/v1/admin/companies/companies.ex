defmodule IexposApi.V1.Admin.Companies.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false

  alias IexposApi.Repo
  alias IexposApi.V1.Admin.Companies.Company

  alias IexposApi.V1.TenantModules.TenantActions

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_company(attrs \\ %{}) do
    changeset = Company.changeset(%Company{}, attrs)

    if changeset.valid? do
      Repo.transaction(fn ->
        tenant = Repo.insert!(changeset)
        TenantActions.create_tenant_database_schema(tenant)
      end)
    else
      {:error, changeset}
    end

  end

end
