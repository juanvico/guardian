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

    if invoice_response == {:error} do
      render(conn, "index.html", %{invoice: %{}, error: true})
    else
      {:ok, invoice} = invoice_response
      render(conn, "index.html", %{invoice: invoice["invoice"], error: false})
    end
  end

  def index(conn, _params, _current_user) do
    render(conn, "index.html", %{invoice: nil, error: false})
  end

  defp transform_date(date) do
    Date.from_iso8601(date)
  end
end
