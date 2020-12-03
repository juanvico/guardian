defmodule Guardian.Invitations do
  import Ecto.Query, warn: false

  alias Guardian.Invitations.Invitation
  alias Guardian.Repo

  def get_invitation_by_token(nil), do: nil

  def get_invitation_by_token(token) do
    Invitation
    |> where(token: ^token)
    |> preload(:organization)
    |> Repo.one()
  end

  def claim_invitation(%Invitation{} = invitation) do
    Repo.delete(invitation)
  end
end
