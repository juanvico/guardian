defmodule Guardian.InvitationsAdminTest do
  use Guardian.DataCase

  alias Guardian.InvitationsAdmin

  describe "invitations" do
    alias Guardian.Invitations.Invitation
    alias Guardian.AccountsFixtures

    @valid_attrs %{email: "some@email.com", token: "asdasdasda", role: "admin"}
    @invalid_attrs %{email: nil, token: nil}

    def invitation_fixture(organization, attrs \\ %{}) do
      attrs = Map.put(attrs, :token, "hfiuhfiuehwifhewifdnw")
      attrs = Enum.into(attrs, @valid_attrs)

      {:ok, invitation} = InvitationsAdmin.create_invitation(organization, attrs)

      invitation
    end

    setup [:create_organization]

    test "paginate_invitations/2 returns paginated list of invitations", %{
      organization: organization
    } do
      for _ <- 1..20 do
        invitation_fixture(organization)
      end

      {:ok, %{invitations: invitations} = page} =
        InvitationsAdmin.paginate_invitations(organization, %{})

      assert length(invitations) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "paginate_invitations/2 returns all invitations for the organization", %{
      organization: organization
    } do
      %Invitation{id: id} = invitation_fixture(organization)

      {:ok, %{invitations: invitations}} =
        InvitationsAdmin.paginate_invitations(organization, %{})

      assert [%Invitation{id: ^id}] = invitations
    end

    test "paginate_invitations/2 does not return invitations for other organizations", %{
      organization: my_organization
    } do
      other_organization = AccountsFixtures.create_organization()
      %Invitation{} = invitation_fixture(other_organization)

      {:ok, %{invitations: invitations}} =
        InvitationsAdmin.paginate_invitations(my_organization, %{})

      assert [] = invitations
    end

    test "get_invitation!/1 returns the invitation with given id", %{organization: organization} do
      %Invitation{id: invitation_id} = invitation_fixture(organization)

      assert %Invitation{id: ^invitation_id} =
               InvitationsAdmin.get_invitation!(organization, invitation_id)
    end

    test "create_invitation/1 with valid data creates a invitation", %{organization: organization} do
      assert {:ok, %Invitation{} = invitation} =
               InvitationsAdmin.create_invitation(organization, @valid_attrs)

      assert invitation.email == "some@email.com"
      assert invitation.token == "asdasdasda"
    end

    test "create_invitation/1 with invalid data returns error changeset", %{
      organization: organization
    } do
      assert {:error, %Ecto.Changeset{}} =
               InvitationsAdmin.create_invitation(
                 organization,
                 @invalid_attrs
               )
    end

    test "delete_invitation/1 deletes the invitation", %{organization: organization} do
      invitation = invitation_fixture(organization)
      assert {:ok, %Invitation{}} = InvitationsAdmin.delete_invitation(invitation)

      assert_raise Ecto.NoResultsError, fn ->
        InvitationsAdmin.get_invitation!(organization, invitation.id)
      end
    end

    test "change_invitation/1 returns a invitation changeset", %{organization: organization} do
      invitation = invitation_fixture(organization)
      assert %Ecto.Changeset{} = InvitationsAdmin.change_invitation(invitation)
    end

    def create_organization(_) do
      {:ok, organization: AccountsFixtures.create_organization()}
    end
  end
end
