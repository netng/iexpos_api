defmodule IexposApiWeb.V1.Stores.Customers.AccountJSON do

  def account(%{account: account}) do
    %{
      data: %{
        email: account.email,
        username: account.username
      }
    }
  end

end
