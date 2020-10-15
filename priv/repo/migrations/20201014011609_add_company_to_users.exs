defmodule Guardian.Repo.Migrations.AddCompanyToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :company_id, references(:companies, on_delete: :delete_all), null: false
    end

    create index(:users, [:company_id])
  end
end
