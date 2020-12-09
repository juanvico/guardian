defmodule GuardianWeb.Admin.InvoicesController do
  use GuardianWeb, :controller

  alias Guardian.InvoicesAdmin

  plug(:put_root_layout, {GuardianWeb.LayoutView, "torch.html"})

  def index(
        conn,
        %{"params" => %{"date_before" => date_before}},
        current_user
      ) do
    {:ok, transformed_date} = transform_date(date_before)

    invoice_response =
      InvoicesAdmin.get_invoices(
        current_user.organization,
        transformed_date.month,
        transformed_date.year
      )

    render(conn, "index.html", %{invoice: invoice_response["invoice"]})
  end

  def index(conn, _params, _current_user) do
    render(conn, "index.html", %{invoice: %{}})
  end

  defp transform_date(date) do
    Date.from_iso8601(date)
  end
end
