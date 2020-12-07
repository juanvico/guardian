defmodule Guardian.Applications do
  import Ecto.Query, warn: false
  alias Guardian.Repo
  import Torch.Helpers, only: [sort: 1, paginate: 4]
  import Filtrex.Type.Config

  alias Guardian.Applications.ApplicationKey
  alias Guardian.Accounts.Organization

  @pagination [page_size: 15]
  @pagination_distance 5

  @spec paginate_application_keys(map) :: {:ok, map} | {:error, any}
  def paginate_application_keys(%Organization{} = organization, params \\ %{}) do
    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <-
           Filtrex.parse_params(
             filter_config(:application_keys),
             params["application_key"] || %{}
           ),
         %Scrivener.Page{} = page <- do_paginate_application_keys(organization, filter, params) do
      {:ok,
       %{
         application_keys: page.entries,
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

  defp do_paginate_application_keys(%Organization{id: organization_id}, filter, params) do
    ApplicationKey
    |> where(organization_id: ^organization_id)
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  def get_application_key!(id), do: Repo.get!(ApplicationKey, id)

  def create_application_key(organization, attrs \\ %{}) do
    %ApplicationKey{}
    |> ApplicationKey.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:organization, organization)
    |> Repo.insert()
  end

  def update_application_key(%ApplicationKey{} = application_key, attrs) do
    application_key
    |> ApplicationKey.changeset(attrs)
    |> Repo.update()
  end

  def delete_application_key(%ApplicationKey{} = application_key) do
    Repo.delete(application_key)
  end

  def change_application_key(%ApplicationKey{} = application_key, attrs \\ %{}) do
    ApplicationKey.changeset(application_key, attrs)
  end

  def application_key_by_key(key) do
    ApplicationKey
    |> where(key: ^key)
    |> preload(:organization)
    |> Repo.one()
  end

  defp filter_config(:application_keys) do
    defconfig do
      text(:environment)
      text(:key)
    end
  end
end
