defmodule GuardianWeb.HealthController do
  use GuardianWeb, :controller

  def show(conn, _params) do
    send_resp(conn, 200, "ok")
  end
end
