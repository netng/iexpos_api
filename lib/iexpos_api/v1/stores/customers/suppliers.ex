defmodule IexposApi.V1.Stores.Customers.Suppliers do
  @moduledoc """
  The Suppliers context.
  """

  import Ecto.Query, warn: false

  alias IexposApi.Repo
  alias IexposApi.V1.Stores.Customers.Supplier

  @schema_prefix "tenant_"

  @doc """
  List all suppliers
  """
  def list_suppliers(codename) do
    Repo.all(Supplier, prefix: @schema_prefix <> String.downcase(codename))
  end

  @doc """
  Creates an supplier.

  ## Examples

      iex> create_supplier(%{field: value}, "tenant_xxx")
      {:ok, %Supplier{}}

      iex> create_supplier(%{field: bad_value}, "tenant_xxx")
      {:error, %Ecto.Changeset{}}
  """
  def create_supplier(attrs \\ %{}, tenant) do
    %Supplier{}
    |> Supplier.changeset(attrs)
    |> Repo.insert(prefix: @schema_prefix <> String.downcase(tenant))
  end

  @doc """
  Gets a single supplier by name

  Returns 'nil' if supplier doest not exist.

  ## Examples

    iex> get_supplier_by_email(test@gmail.com, tenant_name)
    %Supplier{}

    iex> get_supplier_by_email(no_supplier@gmail.com, tenant_name)
    nil
  """
  def get_supplier_by_name(name, tenant) do
    Account
    |> where(name: ^name)
    |> Repo.one(prefix: tenant)
  end

  @doc """
  Gets a single supplier.

  Raises `Ecto.NoResultsError` if the supplier does not exist.

  ## Examples

      iex> get_supplier!(123)
      %Supplier{}

      iex> get_supplier!(456)
      ** (Ecto.NoResultsError)

  """
  def get_supplier!(id, tenant), do: Repo.get!(Supplier, id, prefix: tenant)
end
