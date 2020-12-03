defmodule GuardianWeb.Admin.InvitationControllerTest do
  use GuardianWeb.ConnCase
  use Bamboo.Test

  alias Guardian.InvitationsAdmin

  @create_attrs %{"email" => "some@email.com", "token" => "njfdsjknfnds", "role" => "developer"}
  @invalid_attrs %{"email" => nil, "token" => nil}

  setup context do
    register_and_log_in_user(context)
  end

  def fixture(:invitation, organization) do
    {:ok, invitation} = InvitationsAdmin.create_invitation(organization, @create_attrs)
    invitation
  end

  describe "index" do
    test "lists all invitations", %{conn: conn} do
      conn = get(conn, Routes.admin_invitation_path(conn, :index))
      assert html_response(conn, 200) =~ "Invitations"
    end
  end

  describe "new invitation" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_invitation_path(conn, :new))
      assert html_response(conn, 200) =~ "New Invitation"
    end
  end

  describe "create invitation" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.admin_invitation_path(conn, :create), invitation: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_invitation_path(conn, :show, id)

      conn = get(conn, Routes.admin_invitation_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Invitation Details"
    end

    test "sends an email to join the organization when the invitation is created", %{conn: conn} do
      post conn, Routes.admin_invitation_path(conn, :create), invitation: @create_attrs

      user_email = @create_attrs["email"]

      assert_delivered_email_matches(%{
        to: [{_, ^user_email}],
        html_body: html_body,
        subject: subject
      })

      assert subject =~ ~r/John has invited you to join organization/
      assert html_body =~ ~r{/invitations/.*/accept}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admin_invitation_path(conn, :create), invitation: @invalid_attrs
      assert html_response(conn, 200) =~ "New Invitation"
    end
  end

  describe "delete invitation" do
    setup [:create_invitation]

    test "deletes chosen invitation", %{conn: conn, invitation: invitation} do
      conn = delete(conn, Routes.admin_invitation_path(conn, :delete, invitation))
      assert redirected_to(conn) == Routes.admin_invitation_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_invitation_path(conn, :show, invitation))
      end
    end
  end

  defp create_invitation(%{user: user}) do
    invitation = fixture(:invitation, user.organization)
    {:ok, invitation: invitation}
  end
end
