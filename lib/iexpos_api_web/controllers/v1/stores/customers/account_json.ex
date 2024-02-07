defmodule IexposApiWeb.V1.Stores.Customers.AccountJSON do
  def account_token(%{account: account, token: token, message: message}) do
    %{
      message: message,
      data: %{
        id: account.id,
        email: account.email,
        token: token
      }
    }
  end
end
