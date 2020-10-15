defmodule Guardian.Accounts.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(company, attrs \\ %{}) do
    company
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
