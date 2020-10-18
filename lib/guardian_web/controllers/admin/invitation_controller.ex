defmodule GuardianWeb.Admin.InvitationController do
  use GuardianWeb, :controller

  alias Guardian.InvitationsAdmin
  alias Guardian.Invitations.Invitation
  alias GuardianWeb.InvitationEmail
  alias GuardianWeb.Mailer

  plug(:put_root_layout, {GuardianWeb.LayoutView, "torch.html"})

  def index(conn, params, current_user) do
    case InvitationsAdmin.paginate_invitations(current_user.organization, params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Invitations. #{inspect(error)}")
        |> redirect(to: Routes.admin_invitation_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = InvitationsAdmin.change_invitation(%Invitation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"invitation" => invitation_params}, current_user) do
    invitation_params =
      Map.put(invitation_params, "token", generate_invitation_token(conn, invitation_params))

    case InvitationsAdmin.create_invitation(current_user.organization, invitation_params) do
      {:ok, invitation} ->
        InvitationEmail.send_invitation_email(invitation, current_user)
        |> Mailer.deliver_later()

        conn
        |> put_flash(:info, "Invitation created successfully.")
        |> redirect(to: Routes.admin_invitation_path(conn, :show, invitation))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    invitation = InvitationsAdmin.get_invitation!(current_user.organization, id)
    render(conn, "show.html", invitation: invitation)
  end

  def delete(conn, %{"id" => id}, current_user) do
    invitation = InvitationsAdmin.get_invitation!(current_user.organization, id)
    {:ok, _invitation} = InvitationsAdmin.delete_invitation(invitation)

    conn
    |> put_flash(:info, "Invitation deleted successfully.")
    |> redirect(to: Routes.admin_invitation_path(conn, :index))
  end

  defp generate_invitation_token(conn, %{"email" => email}),
    do: Phoenix.Token.sign(conn, "invitations", %{email: email})

  defp generate_invitation_token(_, _), do: nil
end
