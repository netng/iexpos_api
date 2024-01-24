defmodule IexposApiWeb.Router do
  use IexposApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", IexposApiWeb do
    pipe_through :api
  end

  scope "/api/v1/stores/customers", IexposApiWeb.V1.Stores.Customers do
    pipe_through :api

    post "/sign-up", StoreController, :create
  end
end
