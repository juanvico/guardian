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
  end
end
