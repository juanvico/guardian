defmodule Guardian.Repo.Migrations.AddResolvedToErrors do
  use Ecto.Migration

  def change do
    alter table(:errors) do
      add :resolved, :boolean, null: false, default: false
    end
  end
end
