defmodule GuardianWeb.Admin.ErrorView do
  use GuardianWeb, :view

  import Torch.TableView
  import Torch.FilterView

  def show_assignee(nil), do: "No assignee"
  def show_assignee(assignee), do: assignee.name
end
