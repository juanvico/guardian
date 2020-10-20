defmodule Guardian.ErrorsAdmin do
  import Ecto.Query, warn: false
  alias Guardian.Repo
  import Torch.Helpers, only: [sort: 1, paginate: 4]
  import Filtrex.Type.Config

  alias Guardian.Errors.Error
  alias Guardian.Accounts.Organization

  @pagination [page_size: 15]
  @pagination_distance 5

  @spec paginate_errors(map) :: {:ok, map} | {:error, any}
  def paginate_errors(%Organization{} = organization, params \\ %{}) do
    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:errors), params["error"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_errors(organization, filter, params) do
      {:ok,
       %{
         errors: page.entries,
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

  defp do_paginate_errors(%Organization{id: organization_id}, filter, params) do
    Error
    |> where(organization_id: ^organization_id)
    |> preload(:assignee)
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  def list_errors do
    Error
    |> preload(:assignee)
    |> Repo.all()
  end

  def get_error!(id) do
    Error
    |> preload(:assignee)
    |> Repo.get!(id)
  end

  def update_error(%Error{} = error, attrs) do
    error
    |> Error.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_error(%Error{} = error) do
    Repo.delete(error)
  end

  def change_error(%Error{} = error, attrs \\ %{}) do
    Error.changeset(error, attrs)
  end

  defp filter_config(:errors) do
    defconfig do
      text(:title)
      text(:description)
      boolean(:resolved)
    end
  end
end
