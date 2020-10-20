defmodule Guardian.Applications.ApplicationKey do
  use Ecto.Schema
  import Ecto.Changeset

  alias Guardian.Accounts.Organization

  schema "application_keys" do
    field :environment, :string
    field :key, :string
    belongs_to :organization, Organization

    timestamps()
  end

  @doc false
  def changeset(application_key, attrs) do
    application_key
    |> cast(attrs, [:environment, :key])
    |> validate_required([:environment, :key])
    |> assoc_constraint(:organization)
  end
end
