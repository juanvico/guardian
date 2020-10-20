defmodule GuardianWeb.Admin.ErrorControllerTest do
  use GuardianWeb.ConnCase

  alias Guardian.Errors
  alias Guardian.AccountsFixtures

  @create_attrs %{
    description: "some description",
    resolved: true,
    severity: 2,
    title: "some title"
  }
  @update_attrs %{
    description: "some updated description",
    resolved: false,
    severity: 3,
    title: "some updated title"
  }
  @invalid_attrs %{
    description: nil,
    resolved: nil,
    severity: nil,
    title: nil
  }

  setup context do
    register_and_log_in_user(context)
  end

  def fixture(:error) do
    organization = AccountsFixtures.create_organization()
    {:ok, error} = Errors.create_error(organization, @create_attrs)
    error
  end

  describe "index" do
    test "lists all errors", %{conn: conn} do
      conn = get(conn, Routes.admin_error_path(conn, :index))
      assert html_response(conn, 200) =~ "Errors"
    end
  end

  describe "edit error" do
    setup [:create_error]

    test "renders form for editing chosen error", %{conn: conn, error: error} do
      conn = get(conn, Routes.admin_error_path(conn, :edit, error))
      assert html_response(conn, 200) =~ "Edit Error"
    end
  end

  describe "update error" do
    setup [:create_error]

    test "redirects when data is valid", %{conn: conn, error: error} do
      conn = put conn, Routes.admin_error_path(conn, :update, error), error: @update_attrs
      assert redirected_to(conn) == Routes.admin_error_path(conn, :show, error)

      conn = get(conn, Routes.admin_error_path(conn, :show, error))
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, error: error} do
      conn = put conn, Routes.admin_error_path(conn, :update, error), error: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Error"
    end
  end

  describe "delete error" do
    setup [:create_error]

    test "deletes chosen error", %{conn: conn, error: error} do
      conn = delete(conn, Routes.admin_error_path(conn, :delete, error))
      assert redirected_to(conn) == Routes.admin_error_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_error_path(conn, :show, error))
      end
    end
  end

  defp create_error(_) do
    error = fixture(:error)
    {:ok, error: error}
  end
end
