defmodule Guardian.Applications do
  @moduledoc """
  The Applications context.
  """

  import Ecto.Query, warn: false
  alias Guardian.Repo
import Torch.Helpers, only: [sort: 1, paginate: 4]
import Filtrex.Type.Config

alias Guardian.Applications.ApplicationKey

@pagination [page_size: 15]
@pagination_distance 5

@doc """
Paginate the list of application_keys using filtrex
filters.

## Examples

    iex> list_application_keys(%{})
    %{application_keys: [%ApplicationKey{}], ...}
"""
@spec paginate_application_keys(map) :: {:ok, map} | {:error, any}
def paginate_application_keys(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_config(:application_keys), params["application_key"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_application_keys(filter, params) do
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
      }
    }
  else
    {:error, error} -> {:error, error}
    error -> {:error, error}
  end
end

defp do_paginate_application_keys(filter, params) do
  ApplicationKey
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of application_keys.

## Examples

    iex> list_application_keys()
    [%ApplicationKey{}, ...]

"""
def list_application_keys do
  Repo.all(ApplicationKey)
end

@doc """
Gets a single application_key.

Raises `Ecto.NoResultsError` if the Application key does not exist.

## Examples

    iex> get_application_key!(123)
    %ApplicationKey{}

    iex> get_application_key!(456)
    ** (Ecto.NoResultsError)

"""
def get_application_key!(id), do: Repo.get!(ApplicationKey, id)

@doc """
Creates a application_key.

## Examples

    iex> create_application_key(%{field: value})
    {:ok, %ApplicationKey{}}

    iex> create_application_key(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_application_key(organization, attrs \\ %{}) do
  %ApplicationKey{}
  |> ApplicationKey.changeset(attrs)
  |> Ecto.Changeset.put_assoc(:organization, organization)
  |> Repo.insert()
end

@doc """
Updates a application_key.

## Examples

    iex> update_application_key(application_key, %{field: new_value})
    {:ok, %ApplicationKey{}}

    iex> update_application_key(application_key, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_application_key(%ApplicationKey{} = application_key, attrs) do
  application_key
  |> ApplicationKey.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a ApplicationKey.

## Examples

    iex> delete_application_key(application_key)
    {:ok, %ApplicationKey{}}

    iex> delete_application_key(application_key)
    {:error, %Ecto.Changeset{}}

"""
def delete_application_key(%ApplicationKey{} = application_key) do
  Repo.delete(application_key)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking application_key changes.

## Examples

    iex> change_application_key(application_key)
    %Ecto.Changeset{source: %ApplicationKey{}}

"""
def change_application_key(%ApplicationKey{} = application_key, attrs \\ %{}) do
  ApplicationKey.changeset(application_key, attrs)
end

defp filter_config(:application_keys) do
  defconfig do
    text :environment
      text :key
      
  end
end
end
