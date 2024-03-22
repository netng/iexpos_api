defmodule IexposApiWeb.V1.Stores.Customers.SupplierController do
  use IexposApiWeb, :controller

  alias IexposApi.V1.Stores.Customers.{Suppliers, Supplier}

  action_fallback IexposApiWeb.FallbackController

  def index(conn, _params) do
    suppliers = Suppliers.list_suppliers(current_tenant(conn))
    render(conn, :index, %{suppliers: suppliers, status: "ok"})
  end

  def create(conn, %{"supplier" => supplier_params}) do
    with {:ok, %Supplier{} = supplier} <-
           Suppliers.create_supplier(supplier_params, current_tenant(conn)) do
      conn
      |> put_status(:created)
      |> render(:show, %{supplier: supplier, status: "ok"})
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Supplier{} = supplier} <- Suppliers.fetch_supplier(id, current_tenant(conn)) do
      render(conn, :show, %{supplier: supplier, status: "ok"})
    end
  end

  defp current_tenant(conn) do
    Guardian.Plug.current_claims(conn)["codename"]
  end
end
