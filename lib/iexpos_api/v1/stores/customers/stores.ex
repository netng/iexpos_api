defmodule IexposApi.V1.Stores.Customers.Stores do
  @moduledoc """
  The Stores context.
  """

  import Ecto.Query, warn: false

  alias IexposApi.Repo
  alias IexposApi.V1.Stores.Customers.Store

  alias IexposApi.V1.Helper.TenantActions

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

      Ecto.Multi.new()
      |> Ecto.Multi.run(:create_tenant, fn _, _ ->
        TenantActions.create_tenant_database_schema(codename)
      end)
      |> Ecto.Multi.insert(:insert_store, changeset)
      |> Repo.transaction()
      |> case do
        {:ok, %{create_tenant: _codename, insert_store: changeset}} ->
          {:ok, changeset}
        {:error, :insert_store, changeset, _} ->
          {:error, changeset}
      end
    else
      {:error, changeset}
    end
  end

end
