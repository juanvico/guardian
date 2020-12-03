defmodule Guardian.Errors do
  import Ecto.Query, warn: false
  alias Guardian.Repo

  alias Guardian.Errors.Error
  alias Guardian.Accounts.Organization

  @critical_errors_amount 5

  def create_error(organization, attrs \\ %{}) do
    %Error{}
    |> Error.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:organization, organization)
    |> Repo.insert()
  end

  def change_error(%Error{} = error, attrs \\ %{}) do
    Error.changeset(error, attrs)
  end

  def list_most_critical_errors(%Organization{id: organization_id}) do
    Error
    |> where(organization_id: ^organization_id)
    |> where(resolved: false)
    |> preload(:assignee)
    |> order_by(asc: :severity)
    |> limit(@critical_errors_amount)
    |> Repo.all()
  end
end
