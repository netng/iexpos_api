defmodule IexposApiWeb.V1.Stores.Customers.AccountController do
  use IexposApiWeb, :controller

  alias IexposApiWeb.Auth.ErrorResponses
  alias IexposApi.V1.Stores.Customers.Account
  alias IexposApiWeb.Auth.Guardian

  action_fallback IexposApiWeb.FallbackController

  def sign_in(conn, %{"email" => email, "hash_password" => hash_password, "codename" => codename}) do
    with {:ok, %Account{} = account, token, message} <-
           Guardian.authenticate(email, hash_password, codename) do
      conn
      |> put_session(:account_id, account.id)
      |> put_status(:ok)
      |> render(:account_token, %{account: account, token: token, message: message.message})
    else
      {:error, :unauthorized} ->
        raise ErrorResponses.Unauthorized, message: "Email atau password salah"
    end
  end
end
