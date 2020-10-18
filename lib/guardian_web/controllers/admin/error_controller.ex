defmodule GuardianWeb.Admin.ErrorController do
  use GuardianWeb, :controller

  alias Guardian.ErrorsAdmin
  alias Guardian.Errors.Error
  alias Guardian.Accounts

  plug(:put_root_layout, {GuardianWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    params =
      Map.merge(
        %{
          "error" => %{"resolved_equals" => "true"},
          "sort_direction" => "asc",
          "sort_field" => "severity"
        },
        params
      )

    conn = %{conn | params: params}

    case ErrorsAdmin.paginate_errors(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Errors. #{inspect(error)}")
        |> redirect(to: Routes.admin_error_path(conn, :index))
    end
  end

  def new(conn, _params) do
    users = Accounts.organization_users(conn.assigns.current_user.organization)
    changeset = ErrorsAdmin.change_error(%Error{})
    render(conn, "new.html", changeset: changeset, organization_users: users)
  end

  def create(conn, %{"error" => error_params}) do
    users = Accounts.organization_users(conn.assigns.current_user.organization)

    case ErrorsAdmin.create_error(error_params) do
      {:ok, error} ->
        conn
        |> put_flash(:info, "Error created successfully.")
        |> redirect(to: Routes.admin_error_path(conn, :show, error))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, organization_users: users)
    end
  end

  def show(conn, %{"id" => id}) do
    error = ErrorsAdmin.get_error!(id)
    render(conn, "show.html", error: error)
  end

  def edit(conn, %{"id" => id}) do
    error = ErrorsAdmin.get_error!(id)
    users = Accounts.organization_users(conn.assigns.current_user.organization)
    changeset = ErrorsAdmin.change_error(error)
    render(conn, "edit.html", error: error, changeset: changeset, organization_users: users)
  end

  def update(conn, %{"id" => id, "error" => error_params}) do
    error = ErrorsAdmin.get_error!(id)
    users = Accounts.organization_users(conn.assigns.current_user.organization)

    case ErrorsAdmin.update_error(error, error_params) do
      {:ok, error} ->
        conn
        |> put_flash(:info, "Error updated successfully.")
        |> redirect(to: Routes.admin_error_path(conn, :show, error))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", error: error, changeset: changeset, organization_users: users)
    end
  end

  def delete(conn, %{"id" => id}) do
    error = ErrorsAdmin.get_error!(id)
    {:ok, _error} = ErrorsAdmin.delete_error(error)

    conn
    |> put_flash(:info, "Error deleted successfully.")
    |> redirect(to: Routes.admin_error_path(conn, :index))
  end
end
