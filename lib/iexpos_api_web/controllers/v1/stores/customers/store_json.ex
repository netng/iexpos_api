defmodule IexposApiWeb.V1.Stores.Customers.StoreJSON do
  def store(%{store: store, message: message}) do
    %{
      message: message,
      data: %{
        id: store.id,
        name: store.name,
        codename: store.codename,
        address: store.address
      }
    }
  end

  def store(%{is_exists: is_exists}) do
    %{
      is_exists: is_exists
    }
  end
end
