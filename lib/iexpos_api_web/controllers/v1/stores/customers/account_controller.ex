defmodule IexposApiWeb.V1.Stores.Customers.AccountController do
  use IexposApiWeb, :controller

  alias IexposApi.V1.Stores.Customers.{Stores, Account}
  alias IexposApiWeb.Auth.ErrorResponses
  alias IexposApiWeb.Auth.Guardian

  action_fallback IexposApiWeb.FallbackController

  def sign_in(conn, %{"email" => email, "hash_password" => hash_password, "codename" => codename}) do
    with {:is_store_exists, true} <- {:is_store_exists, Stores.is_exists?(codename)},
         {:ok, %Account{} = account, token, message} <-
           Guardian.authenticate(email, hash_password, codename) do
      conn
      |> Plug.Conn.put_session(:account_id, account.id)
      |> Plug.Conn.put_session(:codename, codename)
      |> put_status(:ok)
      |> IO.inspect(label: "CONNNN Sign In:")
      |> render(:account_token, %{account: account, token: token, message: message.message})
    else
      {:is_store_exists, false} ->
        raise ErrorResponses.NotFound, message: "ID toko tidak ditemukan"

      {:error, :unauthorized} ->
        raise ErrorResponses.Unauthorized, message: "Email atau password salah"
    end
  end

  def refresh_session(conn, %{}) do
    IO.inspect(conn.assigns, label: "ASSIGNS")
    IO.inspect(conn, label: "CONN REFRESH SESSION;")

    old_token = Guardian.Plug.current_token(conn)

    with {:ok, account, new_token, message} <- Guardian.authenticate(old_token) do
      conn
      |> put_session(:account_id, account.id)
      |> put_session(:codename, conn.assigns[:codename])
      |> put_status(:ok)
      |> IO.inspect(label: "CONN REFRESH SESSION;")
      |> render(:account_token, %{account: account, token: new_token, message: message.message})
    else
      {:error, _reason} ->
        raise ErrorResponses.NotFound
    end
  end
end
