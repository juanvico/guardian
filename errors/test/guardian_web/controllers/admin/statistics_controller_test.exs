defmodule GuardianWeb.Admin.StatisticsControllerTest do
  use GuardianWeb.ConnCase

  setup context do
    register_and_log_in_user(context)
  end

  describe "index" do
    test "renders statistics", %{conn: conn} do
      conn = get(conn, Routes.admin_statistics_path(conn, :index))
      assert html_response(conn, 200) =~ "Statistics"
    end
  end
end
