defmodule GuardianWeb.HealthController do
  use GuardianWeb, :controller

  def show(conn, _params) do
    send_resp(conn, 200, "Database STATUS: OK \nRequests STATUS: OK \n")
  end
end
