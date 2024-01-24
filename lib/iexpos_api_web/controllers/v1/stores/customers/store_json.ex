defmodule IexposApiWeb.V1.Stores.Customers.StoreJSON do

  def store(%{store: store}) do
    %{
      data: %{
        name: store.name,
        codename: store.codename,
        email: store.email,
        phone_number: store.phone_number,
        address: store.address
      }
    }
  end

end
