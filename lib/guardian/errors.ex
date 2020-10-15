defmodule Guardian.Errors do
  import Ecto.Query, warn: false
  alias Guardian.Repo

  alias Guardian.Errors.Error

  def create_error(attrs \\ %{}) do
    %Error{}
    |> Error.changeset(attrs)
    |> Repo.insert()
  end

  def change_error(%Error{} = error, attrs \\ %{}) do
    Error.changeset(error, attrs)
  end
end
