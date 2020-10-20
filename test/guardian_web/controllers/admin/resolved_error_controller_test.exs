defmodule GuardianWeb.Admin.ResolvedErrorControllerTest do
  use GuardianWeb.ConnCase

  alias Guardian.Errors
  alias Guardian.AccountsFixtures

  setup context do
    register_and_log_in_user(context)
  end

  def fixture(:error) do
    organization = AccountsFixtures.create_organization()

    {:ok, error} =
      Errors.create_error(organization, %{
        description: "some description",
        resolved: false,
        severity: 2,
        title: "some title"
      })

    error
  end

  describe "mark error as resolved" do
    setup [:create_error]

    test "redirects to index when data was successfully updated", %{conn: conn, error: error} do
      conn = post(conn, Routes.admin_resolved_error_path(conn, :create, error))
      assert redirected_to(conn) == Routes.admin_error_path(conn, :index)
    end
  end

  defp create_error(_) do
    error = fixture(:error)
    {:ok, error: error}
  end
end
