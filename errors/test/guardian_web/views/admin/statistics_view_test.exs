defmodule GuardianWeb.Admin.StatisticsViewTest do
  use ExUnit.Case, async: true

  alias GuardianWeb.Admin.StatisticsView

  test "total_errors_for_severity/2 returns total errors if severity is in list" do
    severity = 2
    errors_by_severity = [%{severity: 2, total_errors: 5}, %{severity: 3, total_errors: 3}]
    assert StatisticsView.total_errors_for_severity(errors_by_severity, severity) == 5
  end

  test "total_errors_for_severity/2 returns empty values if severity is not in errors list" do
    severity = 1
    errors_by_severity = [%{severity: 2, total_errors: 5}, %{severity: 3, total_errors: 3}]
    assert StatisticsView.total_errors_for_severity(errors_by_severity, severity) == 0
  end
end
