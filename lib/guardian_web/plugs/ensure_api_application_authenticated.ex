defmodule GuardianWeb.Plugs.EnsureApiApplicationAuthenticated do
  import Plug.Conn
  alias Guardian.Applications
  alias Guardian.Applications.ApplicationKey

  def init(opts), do: opts

  def call(conn, _opts) do
    with [key] <- get_req_header(conn, "application-key"),
         %ApplicationKey{} = application_key <- Applications.application_key_by_key(key) do
      assign(conn, :application_key, application_key)
    else
      nil ->
        conn
        |> send_resp(401, Jason.encode!(%{message: "Unauthorized Key"}))
        |> halt()
    end
  end
end
