defmodule Guardian.StatisticsAdminTest do
  use Guardian.DataCase

  alias Guardian.AccountsFixtures
  alias Guardian.StatisticsAdmin
  alias Guardian.Errors
  alias Guardian.ErrorsAdmin

  @valid_error_attrs %{
    description: "some description",
    severity: 2,
    title: "some title"
  }

  def fixture(_) do
    organization = AccountsFixtures.create_organization()
    for i <- 1..20 do
      Errors.create_error(organization, %{@valid_error_attrs | severity: rem(i, 4) + 1})
    end
    {:ok, organization: organization}
  end

  setup [:fixture]

  test "get_statistics_report/1 returns errors created amount", %{organization: organization} do
    start_date = Date.add(Date.utc_today(), -1)
    end_date = Date.add(Date.utc_today(), 1)

    %{errors: errors} = StatisticsAdmin.get_statistics_report(organization, start_date, end_date)
    assert errors == 20
  end

  test "get_statistics_report/1 returns resolved errors amount", %{organization: organization} do
    {:ok, error} = Errors.create_error(organization, @valid_error_attrs)
    ErrorsAdmin.resolve_error(error)

    start_date = Date.add(Date.utc_today(), -1)
    end_date = Date.add(Date.utc_today(), 1)

    %{resolved: resolved} = StatisticsAdmin.get_statistics_report(organization, start_date, end_date)
    assert resolved == 1
  end

  test "get_statistics_report/1 returns errors by severity", %{organization: organization} do
    start_date = Date.add(Date.utc_today(), -1)
    end_date = Date.add(Date.utc_today(), 1)

    %{by_severity: by_severity} = StatisticsAdmin.get_statistics_report(organization, start_date, end_date)

    assert length(by_severity) == 4
    assert Enum.find(by_severity, fn %{severity: severity} -> severity == 1 end).total_errors == 5
    assert Enum.find(by_severity, fn %{severity: severity} -> severity == 2 end).total_errors == 5
    assert Enum.find(by_severity, fn %{severity: severity} -> severity == 3 end).total_errors == 5
    assert Enum.find(by_severity, fn %{severity: severity} -> severity == 4 end).total_errors == 5
  end
end
