defmodule GuardianWeb.Api.V1.ErrorControllerTest do
  use GuardianWeb.ConnCase

  @create_attrs %{
    description: "some description",
    severity: 2,
    title: "some title"
  }

  @invalid_attrs %{description: nil, severity: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create error" do
    test "renders error when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_error_path(conn, :create), error: @create_attrs)

      assert %{
               "id" => id,
               "description" => "some description",
               "severity" => 2,
               "title" => "some title"
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_error_path(conn, :create), error: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
