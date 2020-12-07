defmodule GuardianWeb.Admin.AssignationsReportController do
  use GuardianWeb, :controller

  alias Guardian.AssignationsReportAdmin

  plug(:put_root_layout, {GuardianWeb.LayoutView, "torch.html"})

  def index(
        conn,
        _params,
        current_user
      ) do
    %{errors: errors, users: users} = AssignationsReportAdmin.assignations_report(current_user.organization)
    IO.inspect(errors)
    IO.inspect(users)
    render(conn, "index.html", %{assignation_report: %{errors: errors, users: users}})
  end
end
