defmodule Guardian.Errors.Error do
  use Ecto.Schema
  import Ecto.Changeset

  schema "errors" do
    field :assigned_developer, :string
    field :description, :string
    field :severity, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(error, attrs) do
    error
    |> cast(attrs, [:title, :description, :severity, :assigned_developer])
    |> validate_inclusion(:severity, 1..4)
    |> validate_required([:title, :description, :severity, :assigned_developer])
  end
end
