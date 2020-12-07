defmodule Guardian.AcceptedInvitationControllerTest do
  use GuardianWeb.ConnCase, async: true

  alias Guardian.AccountsFixtures
  alias Guardian.InvitationsAdmin

  def fixture(:invitation) do
    organization = AccountsFixtures.create_organization()
    email = "some@email.com"

    attrs = %{
      email: email,
      role: "admin",
      token: Phoenix.Token.sign(GuardianWeb.Endpoint, "invitations", %{email: email})
    }

    {:ok, invitation} = InvitationsAdmin.create_invitation(organization, attrs)

    invitation
  end

  describe "GET /invitations/:token/accept" do
    setup [:create_invitation]

    test "renders the accept invitation form with a valid token", %{
      conn: conn,
      invitation: invitation
    } do
      conn = get(conn, Routes.accepted_invitation_path(conn, :new, invitation.token))

      assert conn.status == 200
      assert get_session(conn, :invitation_token) == invitation.token
    end

    test "tracks the valid tokens in the session", %{conn: conn, invitation: invitation} do
      conn = get(conn, Routes.accepted_invitation_path(conn, :new, invitation.token))
      response = html_response(conn, 200)

      assert response =~ "<b>Role:</b> Admin"
      assert response =~ "You've been invited to join"
      assert response =~ "Accept Invitation"
    end

    test "redirects when the token is not valid", %{conn: conn} do
      conn = get(conn, Routes.accepted_invitation_path(conn, :new, "invalid token"))

      assert redirected_to(conn) =~ "/"

      assert "That invitation does not exist or has already been claimed." =
               get_flash(conn, :error)
    end

    test "redirects with a logged in user", %{conn: conn, invitation: invitation} do
      conn =
        conn
        |> log_in_user(AccountsFixtures.user_fixture())
        |> get(Routes.accepted_invitation_path(conn, :new, invitation.token))

      assert redirected_to(conn) =~ "/"

      assert "You cannot accept the invitation since you already have an account." =
               get_flash(conn, :error)
    end
  end

  describe "POST /accept_invitation" do
    setup [:create_invitation]

    import Guardian.AccountsFixtures

    test "creates account and logs the user in with an existing invitation and correct params", %{
      conn: conn,
      invitation: invitation
    } do
      email = unique_user_email()

      conn =
        conn
        |> Phoenix.ConnTest.init_test_session(%{})
        |> put_session(:invitation_token, invitation.token)
        |> post(Routes.accepted_invitation_path(conn, :create), %{
          "user" => %{
            "email" => email,
            "password" => valid_user_password(),
            "name" => "John"
          }
        })

      assert get_session(conn, :user_token)
      assert "User created successfully." = get_flash(conn, :info)
      assert redirected_to(conn) =~ "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "redirects with an invalid token", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.accepted_invitation_path(conn, :create), %{
          "user" => %{
            "email" => email,
            "password" => valid_user_password(),
            "name" => "John"
          }
        })

      assert redirected_to(conn) =~ "/"

      assert "That invitation does not exist or has already been claimed." =
               get_flash(conn, :error)
    end

    test "renders errors with invalid params", %{conn: conn, invitation: invitation} do
      conn =
        conn
        |> Phoenix.ConnTest.init_test_session(%{})
        |> put_session(:invitation_token, invitation.token)
        |> post(Routes.accepted_invitation_path(conn, :create), %{
          "user" => %{
            "email" => nil,
            "password" => nil,
            "name" => "John"
          }
        })

      response = html_response(conn, 200)
      assert response =~ "Oops, something went wrong! Please check the errors below."
      assert response =~ "can&#39;t be blank"
    end

    test "redirects with a logged in user", %{conn: conn} do
      conn =
        conn
        |> log_in_user(user_fixture())
        |> post(Routes.accepted_invitation_path(conn, :create))

      assert redirected_to(conn) =~ "/"

      assert "You cannot accept the invitation since you already have an account." =
               get_flash(conn, :error)
    end
  end

  def create_invitation(_) do
    {:ok, invitation: fixture(:invitation)}
  end
end
