defmodule GuardianWeb.Admin.InvitationView do
  use GuardianWeb, :view

  import Torch.TableView
  import Torch.FilterView

  alias Guardian.Accounts.User

  def user_roles do
    User
    |> Ecto.Enum.values(:role)
    |> Enum.map(&Atom.to_string/1)
    |> Enum.map(&{String.capitalize(&1), &1})
  end
end
