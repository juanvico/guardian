defmodule GuardianWeb.Admin.StatisticsController do
  use GuardianWeb, :controller

  alias Guardian.StatisticsAdmin

  plug(:put_root_layout, {GuardianWeb.LayoutView, "torch.html"})

  def index(
        conn,
        %{"error" => %{"occurence_between" => %{"start" => start_date, "end" => end_date}}},
        current_user
      ) do
    start_date = transform_date(start_date)
    end_date = transform_date(end_date)

    case StatisticsAdmin.get_statistics_report(current_user.organization, start_date, end_date) do
      {:error} ->
        render(conn, "index.html", %{
          total_errors: 0,
          resolved: 0,
          by_severity: [],
          unassigned_errors: [],
          top_developers: [],
          error: true
        })

      statistics ->
        render(conn, "index.html", Map.put(statistics, :error, false))
    end
  end

  def index(conn, _params, _current_user) do
    render(conn, "index.html", %{
      total_errors: 0,
      resolved: 0,
      by_severity: [],
      unassigned_errors: [],
      top_developers: [],
      error: false
    })
  end

  defp transform_date(date) do
    Date.from_iso8601!(date)
  end
end
