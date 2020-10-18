defmodule Guardian.ErrorsAdminTest do
  use Guardian.DataCase

  alias Guardian.ErrorsAdmin

  describe "errors" do
    alias Guardian.Errors.Error

    @valid_attrs %{
      description: "some description",
      resolved: true,
      severity: 2,
      title: "some title"
    }
    @update_attrs %{
      description: "some updated description",
      resolved: false,
      severity: 3,
      title: "some updated title"
    }
    @invalid_attrs %{
      description: nil,
      resolved: nil,
      severity: nil,
      title: nil
    }

    def error_fixture(attrs \\ %{}) do
      {:ok, error} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ErrorsAdmin.create_error()

      error
    end

    test "paginate_errors/1 returns paginated list of errors" do
      for _ <- 1..20 do
        error_fixture()
      end

      {:ok, %{errors: errors} = page} = ErrorsAdmin.paginate_errors(%{})

      assert length(errors) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_errors/0 returns all errors" do
      %Error{id: id} = error_fixture()
      assert [%Error{id: ^id}] = ErrorsAdmin.list_errors()
    end

    test "get_error!/1 returns the error with given id" do
      %Error{id: id} = error = error_fixture()
      assert %Error{id: ^id} = ErrorsAdmin.get_error!(error.id)
    end

    test "create_error/1 with valid data creates a error" do
      assert {:ok, %Error{} = error} = ErrorsAdmin.create_error(@valid_attrs)
      assert error.description == "some description"
      assert error.resolved == false
      assert error.severity == 2
      assert error.title == "some title"
    end

    test "create_error/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ErrorsAdmin.create_error(@invalid_attrs)
    end

    test "update_error/2 with valid data updates the error" do
      error = error_fixture()
      assert {:ok, error} = ErrorsAdmin.update_error(error, @update_attrs)
      assert %Error{} = error
      assert error.description == "some updated description"
      assert error.resolved == false
      assert error.severity == 3
      assert error.title == "some updated title"
    end

    test "update_error/2 with invalid data returns error changeset" do
      error = error_fixture()
      assert {:error, %Ecto.Changeset{}} = ErrorsAdmin.update_error(error, @invalid_attrs)
      error = ErrorsAdmin.get_error!(error.id)
      assert error.description != @invalid_attrs.description
    end

    test "delete_error/1 deletes the error" do
      error = error_fixture()
      assert {:ok, %Error{}} = ErrorsAdmin.delete_error(error)
      assert_raise Ecto.NoResultsError, fn -> ErrorsAdmin.get_error!(error.id) end
    end

    test "change_error/1 returns a error changeset" do
      error = error_fixture()
      assert %Ecto.Changeset{} = ErrorsAdmin.change_error(error)
    end
  end
end
