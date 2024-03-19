defmodule IexposApiWeb.V1.Stores.Customers.SupplierJSON do
  alias IexposApi.V1.Stores.Customers.Supplier


  def index(%{suppliers: suppliers, status: status}) do
    %{
      status: status,
      data: for(supplier <- suppliers, do: data(supplier)),
    }
  end

  def show(%{supplier: supplier, status: status}) do
    %{status: status, data: data(supplier)}
  end

  defp data(%Supplier{} = supplier) do
    %{
      id: supplier.id,
      name: supplier.name,
      email: supplier.email,
      address: supplier.address,
      phone_number: supplier.phone_number,
      inserted_at: supplier.inserted_at,
      update_at: supplier.updated_at
    }
  end
end
