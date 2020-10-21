defmodule GuardianWeb.Admin.ErrorView do
  use GuardianWeb, :view

  import Torch.TableView
  import Torch.FilterView

  alias Guardian.Accounts.User

  def show_assignee(nil), do: "No assignee"
  def show_assignee(assignee), do: assignee.name

  def admin?(%User{role: :admin}), do: true
  def admin?(_), do: false
end
