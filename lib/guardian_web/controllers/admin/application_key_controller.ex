defmodule GuardianWeb.Admin.ApplicationKeyController do
  use GuardianWeb, :controller

  alias Guardian.Applications
  alias Guardian.Applications.ApplicationKey

  
  plug(:put_root_layout, {GuardianWeb.LayoutView, "torch.html"})
  

  def index(conn, params) do
    organization = conn.assigns.current_user.organization
    case Applications.paginate_application_keys(organization, params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Application keys. #{inspect(error)}")
        |> redirect(to: Routes.admin_application_key_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Applications.change_application_key(%ApplicationKey{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"application_key" => application_key_params}, current_user) do
    case Applications.create_application_key(current_user.organization, application_key_params) do
      {:ok, application_key} ->
        conn
        |> put_flash(:info, "Application key created successfully.")
        |> redirect(to: Routes.admin_application_key_path(conn, :show, application_key))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    application_key = Applications.get_application_key!(id)
    render(conn, "show.html", application_key: application_key)
  end

  def edit(conn, %{"id" => id}) do
    application_key = Applications.get_application_key!(id)
    changeset = Applications.change_application_key(application_key)
    render(conn, "edit.html", application_key: application_key, changeset: changeset)
  end

  def update(conn, %{"id" => id, "application_key" => application_key_params}) do
    application_key = Applications.get_application_key!(id)

    case Applications.update_application_key(application_key, application_key_params) do
      {:ok, application_key} ->
        conn
        |> put_flash(:info, "Application key updated successfully.")
        |> redirect(to: Routes.admin_application_key_path(conn, :show, application_key))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", application_key: application_key, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    application_key = Applications.get_application_key!(id)
    {:ok, _application_key} = Applications.delete_application_key(application_key)

    conn
    |> put_flash(:info, "Application key deleted successfully.")
    |> redirect(to: Routes.admin_application_key_path(conn, :index))
  end
end
