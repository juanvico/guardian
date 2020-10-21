defmodule Guardian.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Guardian.Accounts` context.
  """

  alias Guardian.Accounts.User

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"
  def unique_organization_name, do: "organization #{System.unique_integer()}"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(user_attrs())
      |> Guardian.Accounts.register_user(%{
        name: unique_organization_name()
      })

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end

  def create_organization() do
    organization = %Guardian.Accounts.Organization{name: unique_organization_name()}
    {:ok, organization} = Guardian.Repo.insert(organization)

    organization
  end

  def add_user_to_organization(organization) do
    {:ok, user} =
      %User{}
      |> User.registration_changeset(user_attrs())
      |> Ecto.Changeset.put_assoc(:organization, organization)
      |> Guardian.Repo.insert()

    user
  end

  defp user_attrs() do
    %{
      email: unique_user_email(),
      name: "John",
      password: valid_user_password()
    }
  end
end
