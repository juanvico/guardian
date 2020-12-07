defmodule Guardian.InvoicesAdmin do
  import Ecto.Query, warn: false

  alias Guardian.Repo

  def get_invoices(organization, month, year) do
    {:ok, response} = invoices_info(organization, month, year)
    Jason.decode!(response.body)
  end

  defp invoices_info(organization, month, year) do
    HTTPoison.get(
      "http://localhost:3000/invoices/#{organization.id}?month=#{month}&year=#{year}",
      [
        {"Content-Type", "application/json"}
      ]
    )
  end
end
