defmodule GuardianWeb.Admin.ResolvedErrorController do
  use GuardianWeb, :controller

  alias Guardian.ErrorsAdmin

  def create(conn, %{"id" => id}) do
    error = ErrorsAdmin.get_error!(id)
    {:ok, error} = ErrorsAdmin.resolve_error(error)
    reportError(error)
    conn
    |> put_flash(:info, "Error successfully marked as resolved.")
    |> redirect(to: Routes.admin_error_path(conn, :index))
  end

  defp reportError(error) do
    HTTPoison.patch("http://localhost:3001/errors/#{error.id}/resolved", "", [
      {"Content-Type", "application/json"}
    ])
  end
end
