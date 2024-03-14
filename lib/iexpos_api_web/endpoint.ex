defmodule IexposApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :iexpos_api

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_iexpos_api_key",
    signing_salt: "oUYVfdjQ",
    same_site: "Lax"
  ]

  plug Corsica,
    origins: [
      "http://localhost:4200"
    ],
    allow_headers: ["accept", "content-type", "authorization"],
    allow_credentials: true,
    log: [rejected: :error, invalid: :warn, accepted: :debug]

  # socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :iexpos_api,
    gzip: false,
    only: IexposApiWeb.static_paths()

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :iexpos_api
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug IexposApiWeb.Router
end
