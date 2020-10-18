defmodule Guardian.Repo.Migrations.CreateInvitations do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :token, :string
      add :email, :string
      add :role, :string
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:invitations, [:organization_id])
  end
end
