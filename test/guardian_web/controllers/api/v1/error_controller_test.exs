defmodule GuardianWeb.Api.V1.ErrorControllerTest do
  use GuardianWeb.ConnCase
  use Bamboo.Test

  alias Guardian.AccountsFixtures
  alias Guardian.Applications

  @create_attrs %{
    description: "some description",
    severity: 2,
    title: "some title"
  }

  @invalid_attrs %{description: nil, severity: nil, title: nil}

  setup %{conn: conn} do
    organization = AccountsFixtures.create_organization()

    {:ok, application_key} =
      Applications.create_application_key(organization, %{
        environment: "some environment",
        key: "application_key_test"
      })

    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header("application-key", application_key.key)}
  end

  describe "create error" do
    test "renders error when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_error_path(conn, :create), error: @create_attrs)

      assert %{
               "id" => _id,
               "description" => "some description",
               "severity" => 2,
               "title" => "some title"
             } = json_response(conn, 201)["data"]
    end

    test "sends an email to all the organization admins", %{conn: conn} do
      post(conn, Routes.api_v1_error_path(conn, :create), error: @create_attrs)

      assert_delivered_email_matches(%{
        to: [{_, "juanandresvico8@gmail.com"}],
        html_body: html_body,
        subject: "Attention!! New Error!"
      })

      assert html_body =~ "some title"
      assert html_body =~ "some description"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_error_path(conn, :create), error: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
