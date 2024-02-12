defmodule IexposApiWeb.V1.Stores.Customers.AccountJSON do
  def account_token(%{token: token, expiration_time: expiration_time, message: message}) do
    %{
      message: message,
      data: %{
        token: token,
        expiration_time: expiration_time
      }
    }
  end
end
