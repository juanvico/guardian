defmodule Guardian.ApplicationsTest do
  use Guardian.DataCase

  alias Guardian.Applications
  alias Guardian.AccountsFixtures

  describe "application_keys" do
    alias Guardian.Applications.ApplicationKey

    @valid_attrs %{environment: "some environment", key: "some key"}
    @update_attrs %{environment: "some updated environment", key: "some updated key"}
    @invalid_attrs %{environment: nil, key: nil}

    def application_key_fixture(attrs \\ %{}) do
      organization = Guardian.AccountsFixtures.create_organization()
      attrs = Enum.into(attrs, @valid_attrs)
      {:ok, application_key} = Applications.create_application_key(organization, attrs)

      application_key
    end

    setup [:create_organization]

    test "paginate_application_keys/1 returns paginated list of application_keys", %{
      organization: organization
    } do
      for _ <- 1..20 do
        application_key_fixture()
      end

      {:ok, %{application_keys: application_keys} = page} =
        Applications.paginate_application_keys(organization, %{})

      assert length(application_keys) == 0
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 1
      assert page.total_entries == 0
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "get_application_key!/1 returns the application_key with given id" do
      %ApplicationKey{id: id} = application_key_fixture()
      assert %ApplicationKey{id: ^id} = Applications.get_application_key!(id)
    end

    test "create_application_key/1 with valid data creates a application_key" do
      organization = Guardian.AccountsFixtures.create_organization()

      assert {:ok, %ApplicationKey{} = application_key} =
               Applications.create_application_key(organization, @valid_attrs)

      assert application_key.environment == "some environment"
      assert application_key.key == "some key"
    end

    test "create_application_key/1 with invalid data returns error changeset" do
      organization = Guardian.AccountsFixtures.create_organization()

      assert {:error, %Ecto.Changeset{}} =
               Applications.create_application_key(organization, @invalid_attrs)
    end

    test "update_application_key/2 with valid data updates the application_key" do
      application_key = application_key_fixture()

      assert {:ok, application_key} =
               Applications.update_application_key(application_key, @update_attrs)

      assert %ApplicationKey{} = application_key
      assert application_key.environment == "some updated environment"
      assert application_key.key == "some updated key"
    end

    test "update_application_key/2 with invalid data returns error changeset" do
      application_key = application_key_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Applications.update_application_key(application_key, @invalid_attrs)

      application_key = Applications.get_application_key!(application_key.id)
      refute application_key.environment == "some updated environment"
      refute application_key.key == "some updated key"
    end

    test "delete_application_key/1 deletes the application_key" do
      application_key = application_key_fixture()
      assert {:ok, %ApplicationKey{}} = Applications.delete_application_key(application_key)

      assert_raise Ecto.NoResultsError, fn ->
        Applications.get_application_key!(application_key.id)
      end
    end

    test "change_application_key/1 returns a application_key changeset" do
      application_key = application_key_fixture()
      assert %Ecto.Changeset{} = Applications.change_application_key(application_key)
    end
  end

  def create_organization(_) do
    {:ok, organization: AccountsFixtures.create_organization()}
  end
end
