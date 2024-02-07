defmodule IexposApiWeb.Auth.ErrorResponses.Unauthorized do
  defexception message: "unauthorized", plug_status: 401
end
