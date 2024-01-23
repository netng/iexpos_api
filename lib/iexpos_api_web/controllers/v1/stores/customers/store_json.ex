defmodule IexposApiWeb.V1.Stores.Customers.StoreJSON do

  def store(%{store: store}) do
    %{
      data: %{
        name: store.name,
        codename: store.codename
      }
    }
  end

end
