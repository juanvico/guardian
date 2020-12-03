defmodule GuardianWeb.Admin.ErrorViewTest do
  use ExUnit.Case, async: true

  alias Guardian.Accounts.User
  alias GuardianWeb.Admin.ErrorView

  test "show_assignee/1 returns the assignee name if present" do
    assert ErrorView.show_assignee(%User{name: "John"}) == "John"
  end

  test "show_assignee/1 returns 'No assignee' if the assignee name is not present" do
    assert ErrorView.show_assignee(nil) == "No assignee"
  end
end
