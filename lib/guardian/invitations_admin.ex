defmodule Guardian.InvitationsAdmin do
  @moduledoc """
  The Invitations context.
  """

  import Ecto.Query, warn: false
  alias Guardian.Repo
  import Torch.Helpers, only: [sort: 1, paginate: 4]
  import Filtrex.Type.Config

  alias Guardian.Invitations.Invitation
  alias Guardian.Accounts.Organization

  @pagination [page_size: 15]
  @pagination_distance 5

  def paginate_invitations(%Organization{} = organization, params \\ %{}) do
    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <-
           Filtrex.parse_params(filter_config(:invitations), params["invitation"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_invitations(organization, filter, params) do
      {:ok,
       %{
         invitations: page.entries,
         page_number: page.page_number,
         page_size: page.page_size,
         total_pages: page.total_pages,
         total_entries: page.total_entries,
         distance: @pagination_distance,
         sort_field: sort_field,
         sort_direction: sort_direction
       }}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp do_paginate_invitations(%Organization{id: organization_id}, filter, params) do
    Invitation
    |> where(organization_id: ^organization_id)
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  def get_invitation!(%Organization{id: organization_id}, id) do
    Invitation
    |> where(organization_id: ^organization_id)
    |> Repo.get!(id)
  end

  def create_invitation(organization, attrs \\ %{}) do
    %Invitation{}
    |> Invitation.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:organization, organization)
    |> Repo.insert()
  end

  def delete_invitation(%Invitation{} = invitation) do
    Repo.delete(invitation)
  end

  def change_invitation(%Invitation{} = invitation, attrs \\ %{}) do
    Invitation.changeset(invitation, attrs)
  end

  defp filter_config(:invitations) do
    defconfig do
      text(:email)
    end
  end
end
