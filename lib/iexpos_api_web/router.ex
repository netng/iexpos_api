defmodule IexposApiWeb.Router do
  use IexposApiWeb, :router
  use Plug.ErrorHandler

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{reason: %Phoenix.ActionClauseError{}}) do
    conn |> json(%{errors: "invalid request body"})
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", IexposApiWeb do
    pipe_through :api
  end

  scope "/api/v1/stores/customers", IexposApiWeb.V1.Stores.Customers do
    pipe_through :api

    post "/sign-up", StoreController, :create
    post "/sign-in", AccountController, :sign_in
  end
end
