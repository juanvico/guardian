defmodule Guardian.NotificationConfigAdmin do
  import Ecto.Query, warn: false

  alias Guardian.Repo

  def get_configuration(user) do
    case get_configuration_request(user) do
      {:ok, configuration_response} ->
        case configuration_response.status_code do
          code when code in 200..299 -> {:ok, Jason.decode!(configuration_response.body)}
          _ -> {:error}
        end

      {:error, _error} ->
        {:error}
    end
  end

  defp get_configuration_request(user) do
    HTTPoison.get(
      "http://notifications:3001/users/configuration/#{user.id}",
      [
        {"Content-Type", "application/json"}
      ]
    )
  end
end
