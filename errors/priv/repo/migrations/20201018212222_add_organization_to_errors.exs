defmodule Guardian.Repo.Migrations.AddOrganizationToErrors do
  use Ecto.Migration

  def change do
    alter table(:errors) do
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false
    end
  end
end
