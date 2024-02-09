defmodule IexposApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :iexpos_api,
    module: IexposApiWeb.Auth.Guardian,
    error_handler: IexposApiWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
