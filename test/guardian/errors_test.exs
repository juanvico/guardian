defmodule Guardian.ErrorsTest do
  use Guardian.DataCase

  alias Guardian.Errors

  describe "errors" do
    alias Guardian.Errors.Error

    @valid_attrs %{
      assigned_developer: "some assigned_developer",
      description: "some description",
      severity: 2,
      title: "some title"
    }

    @invalid_attrs %{assigned_developer: nil, description: nil, severity: nil, title: nil}

    test "create_error/1 with valid data creates a error" do
      assert {:ok, %Error{} = error} = Errors.create_error(@valid_attrs)
      assert error.assigned_developer == "some assigned_developer"
      assert error.description == "some description"
      assert error.severity == 2
      assert error.title == "some title"
    end

    test "create_error/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Errors.create_error(@invalid_attrs)
    end
  end
end
