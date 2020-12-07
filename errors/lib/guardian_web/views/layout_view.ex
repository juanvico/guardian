defmodule GuardianWeb.LayoutView do
  use GuardianWeb, :view

  alias Guardian.Accounts.User

  def admin?(%User{role: :admin}), do: true
  def admin?(_), do: false
end
