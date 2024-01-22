defmodule IexposApiWeb.Router do
  use IexposApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", IexposApiWeb do
    pipe_through :api
  end
end
