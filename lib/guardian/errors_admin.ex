defmodule Guardian.ErrorsAdmin do
  @moduledoc """
  The ErrorsAdmin context.
  """

  import Ecto.Query, warn: false
  alias Guardian.Repo
  import Torch.Helpers, only: [sort: 1, paginate: 4]
  import Filtrex.Type.Config

  alias Guardian.Errors.Error

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of errors using filtrex
  filters.

  ## Examples

      iex> list_errors(%{})
      %{errors: [%Error{}], ...}
  """
  @spec paginate_errors(map) :: {:ok, map} | {:error, any}
  def paginate_errors(params \\ %{}) do
    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:errors), params["error"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_errors(filter, params) do
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

  defp do_paginate_errors(filter, params) do
    Error
    |> preload(:assignee)
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of errors.

  ## Examples

      iex> list_errors()
      [%Error{}, ...]

  """
  def list_errors do
    Error
    |> preload(:assignee)
    |> Repo.all()
  end

  @doc """
  Gets a single error.

  Raises `Ecto.NoResultsError` if the Error does not exist.

  ## Examples

      iex> get_error!(123)
      %Error{}

      iex> get_error!(456)
      ** (Ecto.NoResultsError)

  """
  def get_error!(id) do
    Error
    |> preload(:assignee)
    |> Repo.get!(id)
  end

  @doc """
  Creates a error.

  ## Examples

      iex> create_error(%{field: value})
      {:ok, %Error{}}

      iex> create_error(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_error(attrs \\ %{}) do
    %Error{}
    |> Error.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a error.

  ## Examples

      iex> update_error(error, %{field: new_value})
      {:ok, %Error{}}

      iex> update_error(error, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_error(%Error{} = error, attrs) do
    error
    |> Error.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Error.

  ## Examples

      iex> delete_error(error)
      {:ok, %Error{}}

      iex> delete_error(error)
      {:error, %Ecto.Changeset{}}

  """
  def delete_error(%Error{} = error) do
    Repo.delete(error)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking error changes.

  ## Examples

      iex> change_error(error)
      %Ecto.Changeset{source: %Error{}}

  """
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
