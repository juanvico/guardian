defmodule Guardian.AssignationsReportAdmin do
  import Ecto.Query, warn: false

  alias Guardian.Repo
  alias Guardian.Errors.Error
  alias Guardian.Accounts.User

  def assignations_report(organization) do
    {:ok, response} = assignations_report_info(organization)
    decoded_statistics = Jason.decode!(response.body)

    errors =
      Error
      |> where([e], e.id in ^decoded_statistics["statistics"]["errors"])
      |> Repo.all()

    users =
      User
      |> where([u], u.id in ^decoded_statistics["statistics"]["users"])
      |> Repo.all()

    %{errors: errors, users: users}
  end

  defp assignations_report_info(organization) do
    HTTPoison.get(
      "http://localhost:3001/statistics/#{organization.id}",
      [
        {"Content-Type", "application/json"}
      ]
    )
  end
end
