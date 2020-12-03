defmodule Guardian.Repo.Migrations.CreateApplicationKeys do
  use Ecto.Migration

  def change do
    create table(:application_keys) do
      add :environment, :string
      add :key, :string
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:application_keys, [:organization_id])
  end
end
