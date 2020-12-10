defmodule GuardianWeb.Api.V1.ErrorController do
  use GuardianWeb, :controller

  alias Guardian.Errors
  alias Guardian.Errors.Error
  alias GuardianWeb.Mailer
  alias GuardianWeb.ErrorEmail
  alias Guardian.Accounts
  alias GuardianWeb.Queue

  action_fallback GuardianWeb.FallbackController

  @topic_error_add "errors_add"
  @topic_create_error "create_error"

  def index(conn, _, application_key) do
    {_status, {:ok, errors}} =
      Cachex.fetch(
        :errors,
        "most-critical-errors-#{application_key.organization.id}",
        fn _ ->
          {:ok, Errors.list_most_critical_errors(application_key.organization)}
        end,
        ttl: :timer.minutes(10)
      )

    render(conn, "index.json", errors: errors)
  end

  def create(conn, %{"error" => error_params}, application_key) do
    with {:ok, %Error{} = error} <-
           Errors.create_error(application_key.organization, error_params) do
      users = Accounts.organization_users(application_key.organization)
      reportError(error, application_key.organization)

      ErrorEmail.new_error_email(error, users)
      |> Mailer.deliver_later()

      conn
      |> put_status(:created)
      |> render("show.json", error: error)
    end
  end

  defp reportError(error, organization) do
    Queue.publish(@topic_create_error, Jason.encode!(%{
      "error_id" => error.id,
      "severity" => error.severity,
      "resolved" => error.resolved,
      "org_id" => organization.id,
      "description" => error.description,
      "assigned_developer" => error.assignee_id,
      "title" => error.title
    }))
    Queue.publish(@topic_error_add, Jason.encode!(%{
      "org_id" => organization.id
    }))
  end

end
