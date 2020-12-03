defmodule Guardian.InvitationsTest do
  use Guardian.DataCase

  alias Guardian.AccountsFixtures
  alias Guardian.Invitations
  alias Guardian.Invitations.Invitation
  alias Guardian.InvitationsAdmin

  def fixture(:invitation) do
    organization = AccountsFixtures.create_organization()
    attrs = %{email: "some@email.com", role: "admin", token: "123123"}

    {:ok, invitation} = InvitationsAdmin.create_invitation(organization, attrs)

    invitation
  end

  test "get_invitation_by_token/1 returns the invitation when it exists" do
    %Invitation{id: invitation_id, token: token} = fixture(:invitation)
    assert %Invitation{id: ^invitation_id} = Invitations.get_invitation_by_token(token)
  end

  test "get_invitation_by_token/1 returns nil when the invitation does not exists" do
    refute Invitations.get_invitation_by_token("abcd")
  end

  test "claim_invitation/1 deletes the invitation" do
    %Invitation{token: token} = invitation = fixture(:invitation)

    Invitations.claim_invitation(invitation)

    refute Invitations.get_invitation_by_token(token)
  end
end
