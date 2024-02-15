defmodule IexposApiWeb.V1.Stores.Customers.AccountController do
  use IexposApiWeb, :controller

  alias IexposApi.V1.Stores.Customers.Store
  alias IexposApi.V1.Stores.Customers.{Stores, Account}
  alias IexposApiWeb.Auth.ErrorResponses
  alias IexposApiWeb.Auth.Guardian

  action_fallback IexposApiWeb.FallbackController

  def sign_in(conn, %{"email" => email, "hash_password" => hash_password, "codename" => codename}) do
    with {:is_store_exists, true} <- {:is_store_exists, Stores.is_exists?(codename)},
         {:ok, %Account{} = account, token, expiration_time, message} <-
           Guardian.authenticate(email, hash_password, codename) do
      conn
      |> put_session(:account_id, account.id)
      |> put_session(:codename, codename)
      |> put_session(:guardian_default_token, token)
      |> put_status(:ok)
      |> render(:account_token, %{
        token: token,
        expiration_time: expiration_time,
        message: message.message
      })
    else
      {:is_store_exists, false} ->
        raise ErrorResponses.NotFound, message: "ID toko tidak ditemukan"

      {:error, :unauthorized} ->
        raise ErrorResponses.Unauthorized, message: "Email atau password salah"
    end
  end

  def refresh_session(conn, %{}) do
    old_token = Guardian.Plug.current_token(conn)
    %Store{codename: codename} = conn.assigns[:store]

    with {:ok, account, new_token, expiration_time, message} <- Guardian.authenticate(old_token) do
      conn
      |> put_session(:account_id, account.id)
      |> put_session(:codename, codename)
      |> put_session(:guardian_default_token, new_token)
      |> put_status(:ok)
      |> render(:account_token, %{
        account: account,
        token: new_token,
        expiration_time: expiration_time,
        message: message.message
      })
    else
      {:error, _reason} ->
        raise ErrorResponses.NotFound
    end
  end

  def is_connected(conn, %{}) do
    old_token = Guardian.Plug.current_token(conn)
    %Store{codename: codename} = conn.assigns[:store]

    with {:ok, account, new_token, expiration_time, _message} <-
           Guardian.authenticate(old_token) do
      conn
      |> put_status(:ok)
      |> put_session(:account_id, account.id)
      |> put_session(:codename, codename)
      |> put_session(:guardian_default_token, new_token)
      |> render(:account_is_connected, %{connected: true})
    else
      {:error, _reason} ->
        raise ErrorResponses.NotFound
    end
  end
end
