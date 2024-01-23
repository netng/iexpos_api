defmodule IexposApi.V1.Stores.Customers.Stores do
  @moduledoc """
  The Stores context.
  """

  import Ecto.Query, warn: false

  alias IexposApi.Repo
  alias IexposApi.V1.Stores.Customers.Store

  alias IexposApi.V1.Services.TenantServices

  @doc """
  Creates a store (we call it as tenant).
  Will create a new schema with prefix tenant_[code]

  ## Examples

      iex> create_store(%{field: value})
      {:ok, %store{}}

      iex> create_store(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_store(attrs \\ %{}) do
    changeset = Store.changeset(%Store{}, attrs)

    if changeset.valid? do
      codename = Ecto.Changeset.get_field(changeset, :codename)
      Repo.transaction(fn ->
        TenantServices.create_tenant_database_schema(codename)
        Repo.insert!(changeset)
      end)
    else
      {:error, changeset}
    end
  end

end
