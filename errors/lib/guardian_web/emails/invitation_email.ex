defmodule GuardianWeb.InvitationEmail do
  use GuardianWeb, :email
  alias Guardian.Invitations.Invitation

  def send_invitation_email(%Invitation{email: email} = invitation, sender) do
    new_email(
      to: email,
      from: "juanandresvico@hotmail.com",
      subject: "#{sender.name} has invited you to join #{sender.organization.name} on Guardian!",
      html_body: email_body(:send_invitation, :html, invitation: invitation, sender: sender),
      text_body: email_body(:send_invitation, :text, invitation: invitation, sender: sender)
    )
  end
end
