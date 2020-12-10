defmodule Guardian.InvoicesAdmin do
  import Ecto.Query, warn: false

  alias Guardian.Repo

  def get_invoices(organization, month, year) do
    case invoices_info(organization, month, year) do
      {:ok, invoices_request} ->
        case invoices_request.status_code do
          code when code in 200..299 -> {:ok, Jason.decode!(invoices_request.body)}
          _ -> {:error}
        end

      {:error, error} ->
        {:error}
    end
  end

  defp invoices_info(organization, month, year) do
    HTTPoison.get(
      "http://billing:3000/invoices/#{organization.id}?month=#{month}&year=#{year}",
      [
        {"Content-Type", "application/json"},
        {"Server-key", System.fetch_env!("SERVER_KEY")}
      ]
    )
  end
end
