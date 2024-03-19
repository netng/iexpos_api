defmodule IexposApiWeb.V1.Stores.Customers.SupplierController do
  use IexposApiWeb, :controller

  alias IexposApi.V1.Stores.Customers.{Suppliers, Supplier}
  alias IexposApiWeb.Auth.Guardian

  action_fallback IexposApiWeb.FallbackController

  def index(conn, %{"codename" => codename}) do
    suppliers = Suppliers.list_suppliers(codename)
    render(conn, :index, %{suppliers: suppliers, status: "ok"})
  end

  def create(conn, %{"supplier" => supplier_params, "codename" => codename}) do
    current_token = Guardian.Plug.current_token(conn)
    with {:ok, %Supplier{} = supplier} <- Suppliers.create_supplier(supplier_params, codename) do
      IO.inspect(Guardian.decode_and_verify(current_token), label: "CLAIMSS_")
      render(conn, :show, %{supplier: supplier, status: "ok"})
    end
  end
end
