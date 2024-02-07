defmodule IexposApiWeb.V1.Stores.Customers.StoreController do
  use IexposApiWeb, :controller

  alias IexposApi.V1.Stores.Customers.Stores
  alias IexposApi.V1.Stores.Customers.Store

  action_fallback IexposApiWeb.FallbackController

  def create(conn, %{"store" => store_params, "account" => account_params, "user" => user_params}) do
    with {:ok, %Store{} = store, message} <-
           Stores.create_store(store_params, account_params, user_params) do
      # send email confirmation
      conn
      |> put_status(:ok)
      |> render(:store, %{store: store, message: message.message})
    end
  end
end
