defmodule GuardianWeb.Admin.NotificationConfigController do
  use GuardianWeb, :controller

  alias Guardian.InvoicesAdmin

  plug(:put_root_layout, {GuardianWeb.LayoutView, "torch.html"})

  def index(
        conn,
        _params,
        _current_user
      ) do



    render(conn, "index.html", %{config: %{}})
  end

  def index(conn, _params, _current_user) do
    # get user configuration
    render(conn, "index.html", %{config: %{}})
  end

  defp transform_date(date) do
    Date.from_iso8601(date)
  end
end
