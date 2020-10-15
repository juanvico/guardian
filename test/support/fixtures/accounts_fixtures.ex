defmodule Guardian.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Guardian.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"
  def unique_company_name, do: "company #{System.unique_integer()}"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        name: "John",
        password: valid_user_password()
      })
      |> Guardian.Accounts.register_user(%{
        name: unique_company_name()
      })

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
