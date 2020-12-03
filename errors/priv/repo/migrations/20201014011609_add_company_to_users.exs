defmodule Guardian.Repo.Migrations.AddOrganizationToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false
    end

    create index(:users, [:organization_id])
  end
end
