defmodule GuardianWeb.Admin.StatisticsView do
  use GuardianWeb, :view

  import Torch.TableView
  import Torch.FilterView

  def total_errors_for_severity(errors_by_severity, current_severity) do
    total_errors =
      Enum.find(errors_by_severity, fn %{severity: severity} -> severity == current_severity end)[
        :total_errors
      ]

    total_errors || 0
  end
end
