defmodule Guardian.Errors.Error do
  use Ecto.Schema
  import Ecto.Changeset

  alias Guardian.Accounts.{Organization, User}

  schema "errors" do
    belongs_to :assignee, User
    belongs_to :organization, Organization
    field :description, :string
    field :severity, :integer, default: 1
    field :title, :string
    field :resolved, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(error, attrs) do
    error
    |> cast(attrs, [:title, :description, :severity])
    |> validate_inclusion(:severity, 1..4)
    |> validate_required([:title])
  end

  def update_changeset(error, attrs) do
    error
    |> cast(attrs, [:title, :description, :severity, :assignee_id, :resolved])
    |> validate_inclusion(:severity, 1..4)
    |> validate_required([:title])
    |> assoc_constraint(:assignee)
    |> assoc_constraint(:organization)
  end
end
