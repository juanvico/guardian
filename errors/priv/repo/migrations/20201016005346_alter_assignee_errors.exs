defmodule Guardian.Repo.Migrations.AlterAssigneeErrors do
  use Ecto.Migration

  def change do
    alter table(:errors) do
      add :assignee_id, references(:users, on_delete: :nothing)
      remove :assigned_developer, :string
    end
  end
end
