defmodule Guardian.Repo.Migrations.CreateErrors do
  use Ecto.Migration

  def change do
    create table(:errors) do
      add :title, :string
      add :description, :string
      add :severity, :integer
      add :assigned_developer, :string

      timestamps()
    end
  end
end
