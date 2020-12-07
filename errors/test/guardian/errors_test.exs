defmodule Guardian.ErrorsTest do
  use Guardian.DataCase

  alias Guardian.Errors
  alias Guardian.AccountsFixtures

  describe "errors" do
    alias Guardian.Errors.Error

    @valid_attrs %{
      description: "some description",
      severity: 2,
      title: "some title"
    }

    @invalid_attrs %{description: nil, severity: nil, title: nil}

    test "create_error/1 with valid data creates a error" do
      organization = AccountsFixtures.create_organization()

      assert {:ok, %Error{} = error} = Errors.create_error(organization, @valid_attrs)
      assert error.description == "some description"
      assert error.severity == 2
      assert error.title == "some title"
    end

    test "create_error/1 with invalid data returns error changeset" do
      organization = AccountsFixtures.create_organization()
      assert {:error, %Ecto.Changeset{}} = Errors.create_error(organization, @invalid_attrs)
    end

    test "list_most_critical_errors/1 returns 5 most critical unresolved errors" do
      organization = AccountsFixtures.create_organization()
      organization2 = AccountsFixtures.create_organization()

      for i <- 1..20 do
        Errors.create_error(organization, %{@valid_attrs | severity: rem(i, 3) + 2})
      end

      {:ok, error} = Errors.create_error(organization2, %{@valid_attrs | severity: 1})
      Errors.change_error(error, %{resolved: false})

      [error | _] = errors = Errors.list_most_critical_errors(organization)
      assert length(errors) == 5
      assert error.severity == 2
    end
  end
end
