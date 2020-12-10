defmodule Guardian.InvoicesAdmin do
  import Ecto.Query, warn: false

  alias Guardian.Repo

  def get_invoices(organization, month, year) do
    case invoices_info(organization, month, year) do
      {:ok, invoices_request} -> {:ok, Jason.decode!(invoices_request.body)}
      {:error, _error} -> {:error}
    end
  end

  defp invoices_info(organization, month, year) do
    HTTPoison.get(
      "http://billing:3000/invoices/#{organization.id}?month=#{month}&year=#{year}",
      [
        {"Content-Type", "application/json"}
      ]
    )
  end
end
