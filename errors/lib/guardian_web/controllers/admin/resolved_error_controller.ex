defmodule GuardianWeb.Admin.ResolvedErrorController do
  use GuardianWeb, :controller

  alias Guardian.ErrorsAdmin
  alias GuardianWeb.Queue

  @topic_resolve_error "resolve_error"

  def create(conn, %{"id" => id}) do
    error = ErrorsAdmin.get_error!(id)
    {:ok, error} = ErrorsAdmin.resolve_error(error)
    reportError(error)

    conn
    |> put_flash(:info, "Error successfully marked as resolved.")
    |> redirect(to: Routes.admin_error_path(conn, :index))
  end

  defp reportError(error) do
    Queue.publish(
      @topic_resolve_error,
      Jason.encode!(%{
        "error_id" => error.id
      })
    )
  end
end
