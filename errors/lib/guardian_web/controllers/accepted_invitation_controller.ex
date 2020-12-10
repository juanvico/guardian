defmodule GuardianWeb.AcceptedInvitationController do
  use GuardianWeb, :controller

  alias Guardian.Accounts
  alias Guardian.Accounts.User
  alias Guardian.Invitations
  alias Guardian.Invitations.Invitation
  alias GuardianWeb.UserAuth
  alias GuardianWeb.Queue

  @topic_users_add "users_add"

  def new(conn, %{"token" => token}, nil) do
    case Invitations.get_invitation_by_token(token) do
      %Invitation{organization: organization, role: role} ->
        {:ok, %{email: email}} = Phoenix.Token.verify(GuardianWeb.Endpoint, "invitations", token)
        changeset = Accounts.change_user_registration(%User{email: email})
        role = role |> Atom.to_string() |> String.capitalize()

        conn
        |> put_session(:invitation_token, token)
        |> render("new.html", organization: organization, role: role, changeset: changeset)

      nil ->
        conn
        |> put_flash(:error, "That invitation does not exist or has already been claimed.")
        |> redirect(to: "/")
    end
  end

  def new(conn, _params, _current_user) do
    conn
    |> put_flash(:error, "You cannot accept the invitation since you already have an account.")
    |> redirect(to: "/")
  end

  def create(conn, %{"user" => user_params}, nil) do
    case Invitations.get_invitation_by_token(get_session(conn, :invitation_token)) do
      %Invitation{organization: organization, role: role} = invitation ->
        case Accounts.join_through_invitation(organization, Map.put(user_params, "role", role)) do
          {:ok, user} ->
            Invitations.claim_invitation(invitation)
            reportNewUserToOrg(organization)

            conn
            |> delete_session(:invitation_token)
            |> put_flash(:info, "User created successfully.")
            |> UserAuth.log_in_user(user)

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", organization: organization, role: role, changeset: changeset)
        end

      nil ->
        conn
        |> put_flash(:error, "That invitation does not exist or has already been claimed.")
        |> redirect(to: "/")
    end
  end

  def create(conn, _params, _current_user) do
    conn
    |> put_flash(:error, "You cannot accept the invitation since you already have an account.")
    |> redirect(to: "/")
  end

  defp reportNewUserToOrg(organization) do
    Queue.publish(@topic_users_add, Jason.encode!(%{
      "org_id" => organization.id
    }))
  end
end
