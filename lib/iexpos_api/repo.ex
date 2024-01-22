defmodule IexposApi.Repo do
  use Ecto.Repo,
    otp_app: :iexpos_api,
    adapter: Ecto.Adapters.Postgres
end
