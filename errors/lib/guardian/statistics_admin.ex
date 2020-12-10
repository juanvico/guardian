defmodule Guardian.StatisticsAdmin do
  import Ecto.Query, warn: false

  alias Guardian.Repo
  alias Guardian.Errors.Error
  alias Guardian.Accounts.User

  def get_statistics_report(organization, start_date, end_date) do
    statistic_response =
      case get_statistics_report_info(organization, start_date, end_date) do
        {:ok, statistics} ->
          case statistics.status_code do
            code when code in 200..299 -> {:ok, Jason.decode!(statistics.body)}
            _ -> {:error}
          end

        {:error, _error} ->
          {:error}
      end

    if statistic_response != {:error} do
      {:ok, decoded_statistics} = statistic_response

      top_developers_ids =
        Enum.map(decoded_statistics["top_developers"], fn developer -> developer["_id"] end)

      unassigned_errors =
        case decoded_statistics["unassigned_errors"] do
          [] ->
            []

          _ ->
            Error
            |> where([e], e.id in ^decoded_statistics["unassigned_errors"])
            |> Repo.all()
        end

      top_developers =
        case top_developers_ids do
          [] ->
            []

          _ ->
            User
            |> where([u], u.id in ^top_developers_ids)
            |> Repo.all()
        end

      %{
        unassigned_errors: unassigned_errors,
        top_developers: top_developers,
        by_severity: decoded_statistics["by_severity"],
        resolved: decoded_statistics["resolved"],
        total_errors: decoded_statistics["total_errors"]
      }
    else
      {:error}
    end
  end

  defp get_statistics_report_info(organization, start_date, end_date) do
    transformed_start_date = transform_date(start_date)
    transformed_end_date = transform_date(end_date)

    HTTPoison.get(
      "http://localhost:3002/statistics/#{organization.id}?start=#{transformed_start_date}&end=#{
        transformed_end_date
      }",
      [
        {"Content-Type", "application/json"}
      ]
    )
  end

  defp transform_date(date) do
    Date.to_string(date)
  end
end
