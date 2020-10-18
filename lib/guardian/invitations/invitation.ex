defmodule Guardian.Invitations.Invitation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invitations" do
    field :email, :string
    field :token, :string
    field :role, Ecto.Enum, values: Ecto.Enum.values(Guardian.Accounts.User, :role)
    belongs_to :organization, Guardian.Accounts.Organization

    timestamps()
  end

  @doc false
  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, [:token, :email, :role])
    |> validate_required([:token, :email, :role])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> assoc_constraint(:organization)
  end
end
