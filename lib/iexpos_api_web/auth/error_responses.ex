defmodule IexposApiWeb.Auth.ErrorResponses.Unauthorized do
  defexception message: "unauthorized", plug_status: 401
end

defmodule IexposApiWeb.Auth.ErrorResponses.NotFound do
  defexception message: "not_found", plug_status: 404
end
