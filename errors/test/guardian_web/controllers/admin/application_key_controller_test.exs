defmodule GuardianWeb.Admin.ApplicationKeyControllerTest do
  use GuardianWeb.ConnCase

  alias Guardian.Applications
  alias GuardianWeb.Token

  @create_attrs %{environment: "some environment"}
  @update_attrs %{environment: "some updated environment"}
  @invalid_attrs %{environment: nil, key: nil}

  setup context do
    register_and_log_in_user(context)
  end

  def fixture(:application_key, organization) do
    {:ok, api_key, _} = Token.generate_and_sign()

    {:ok, application_key} =
      Applications.create_application_key(organization, Map.put(@create_attrs, :key, api_key))

    application_key
  end

  describe "index" do
    test "lists all application_keys", %{conn: conn} do
      conn = get(conn, Routes.admin_application_key_path(conn, :index))
      assert html_response(conn, 200) =~ "Application keys"
    end
  end

  describe "new application_key" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_application_key_path(conn, :new))
      assert html_response(conn, 200) =~ "New Application key"
    end
  end

  describe "create application_key" do
    test "redirects to show when data is valid", %{conn: conn} do
      {:ok, api_key, _} = Token.generate_and_sign()

      conn =
        post conn, Routes.admin_application_key_path(conn, :create),
          application_key: Map.put(@create_attrs, :key, api_key)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_application_key_path(conn, :show, id)

      conn = get(conn, Routes.admin_application_key_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Application key Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post conn, Routes.admin_application_key_path(conn, :create),
          application_key: @invalid_attrs

      assert html_response(conn, 200) =~ "New Application key"
    end
  end

  describe "edit application_key" do
    setup [:create_application_key]

    test "renders form for editing chosen application_key", %{
      conn: conn,
      application_key: application_key
    } do
      conn = get(conn, Routes.admin_application_key_path(conn, :edit, application_key))
      assert html_response(conn, 200) =~ "Edit Application key"
    end
  end

  describe "update application_key" do
    setup [:create_application_key]

    test "redirects when data is valid", %{conn: conn, application_key: application_key} do
      conn =
        put conn, Routes.admin_application_key_path(conn, :update, application_key),
          application_key: @update_attrs

      assert redirected_to(conn) ==
               Routes.admin_application_key_path(conn, :show, application_key)

      conn = get(conn, Routes.admin_application_key_path(conn, :show, application_key))
      assert html_response(conn, 200) =~ "some updated environment"
    end

    test "renders errors when data is invalid", %{conn: conn, application_key: application_key} do
      conn =
        put conn, Routes.admin_application_key_path(conn, :update, application_key),
          application_key: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit Application key"
    end
  end

  describe "delete application_key" do
    setup [:create_application_key]

    test "deletes chosen application_key", %{conn: conn, application_key: application_key} do
      conn = delete(conn, Routes.admin_application_key_path(conn, :delete, application_key))
      assert redirected_to(conn) == Routes.admin_application_key_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_application_key_path(conn, :show, application_key))
      end
    end
  end

  defp create_application_key(%{user: user}) do
    application_key = fixture(:application_key, user.organization)
    {:ok, application_key: application_key}
  end
end
