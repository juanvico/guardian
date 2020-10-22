defmodule GuardianWeb.PageLiveTest do
  use GuardianWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Guardian!"
    assert render(page_live) =~ "Welcome to Guardian!"
  end
end
