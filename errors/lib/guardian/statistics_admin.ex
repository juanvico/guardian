defmodule Guardian.StatisticsAdmin do
  import Ecto.Query, warn: false

  alias Guardian.Repo
  alias Guardian.Errors.Error

  def get_statistics_report(organization, start_date, end_date) do
    errors = count_errors_between_dates(organization, start_date, end_date)
    resolved = count_resolved_errors_between_dates(organization, start_date, end_date)
    by_severity = count_errors_by_severity_between_dates(organization, start_date, end_date)

    %{errors: errors, resolved: resolved, by_severity: by_severity}
  end

  defp count_errors_between_dates(organization, start_date, end_date) do
    query_errors_between_dates(organization, start_date, end_date)
    |> select([e], count(e.id))
    |> Repo.one()
  end

  defp count_resolved_errors_between_dates(organization, start_date, end_date) do
    query_errors_between_dates(organization, start_date, end_date)
    |> where(resolved: true)
    |> select([e], count(e.id))
    |> Repo.one()
  end

  defp count_errors_by_severity_between_dates(organization, start_date, end_date) do
    query_errors_between_dates(organization, start_date, end_date)
    |> group_by([e], e.severity)
    |> select([e], %{severity: e.severity, total_errors: count(e.id)})
    |> Repo.all()
  end

  defp query_errors_between_dates(organization, start_date, end_date) do
    Error
    |> where([e], fragment("?::date", e.inserted_at) > ^start_date)
    |> where([e], fragment("?::date", e.inserted_at) < ^end_date)
    |> where(organization_id: ^organization.id)
  end
end
