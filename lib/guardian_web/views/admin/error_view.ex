defmodule GuardianWeb.Admin.ErrorView do
  use GuardianWeb, :view

  import Torch.TableView
  import Torch.FilterView

  defp show_assignee(nil), do: "No assignee"
  defp show_assignee(assignee), do: assignee.name
end
