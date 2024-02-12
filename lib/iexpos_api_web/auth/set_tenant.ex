defmodule IexposApiWeb.Auth.SetTenant do
  import Plug.Conn
  alias IexposApi.V1.Stores.Customers.Stores
  alias IexposApiWeb.Auth.ErrorResponses

  @doc """
  we call tenant as codename
  """
  def init(_options) do
  end

  def call(conn, _options) do
    if conn.assigns[:codename] do
      conn
    else
      codename = get_session(conn, :codename)

      if codename == nil, do: raise(ErrorResponses.Unauthorized)
      store = Stores.get_store_by_codename(codename)

      cond do
        codename && store ->
          assign(conn, :codename, codename)
          assign(conn, :store, store)

        true ->
          assign(conn, :codename, nil)
      end
    end
  end
end
