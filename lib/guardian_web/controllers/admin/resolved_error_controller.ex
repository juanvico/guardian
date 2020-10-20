defmodule GuardianWeb.Admin.ResolvedErrorController do
  use GuardianWeb, :controller

  alias Guardian.ErrorsAdmin

  def create(conn, %{"id" => id}) do
    error = ErrorsAdmin.get_error!(id)
    {:ok, _error} = ErrorsAdmin.resolve_error(error)

    conn
    |> put_flash(:info, "Error successfully marked as resolved.")
    |> redirect(to: Routes.admin_error_path(conn, :index))
  end
end
