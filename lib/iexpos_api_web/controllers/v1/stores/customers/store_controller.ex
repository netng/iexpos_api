defmodule IexposApiWeb.V1.Stores.Customers.StoreController do
  use IexposApiWeb, :controller

  alias IexposApi.V1.Stores.Customers.Stores
  alias IexposApi.V1.Stores.Customers.Store

  action_fallback IexposApiWeb.FallbackController

  def create(conn, %{"store" => store_params}) do
    with {:ok, %Store{} = store} <- Stores.create_store(store_params) do
      conn
      |> put_status(:ok)
      |> render(:store, %{store: store})
    end
  end

end
