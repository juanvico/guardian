defmodule GuardianWeb.Api.V1.ErrorController do
  use GuardianWeb, :controller

  alias Guardian.Errors
  alias Guardian.Errors.Error
  alias GuardianWeb.Mailer
  alias GuardianWeb.ErrorEmail
  alias Guardian.Accounts

  action_fallback GuardianWeb.FallbackController

  def index(conn, _, application_key) do
    cached_errors =
      Cachex.fetch(
        :errors,
        "most-critical-errors-#{application_key.organization.id}",
        fn _ ->
          {:ok, Errors.list_most_critical_errors(application_key.organization)}
        end,
        ttl: :timer.minutes(10)
      )

    errors =
      case cached_errors do
        {:ok, errors} -> errors
        {:commit, {:ok, errors}} -> errors
      end

    render(conn, "index.json", errors: errors)
  end

  def create(conn, %{"error" => error_params}, application_key) do
    with {:ok, %Error{} = error} <-
           Errors.create_error(application_key.organization, error_params) do
      users = Accounts.organization_users(application_key.organization)

      ErrorEmail.new_error_email(error, users)
      |> Mailer.deliver_later()

      conn
      |> put_status(:created)
      |> render("show.json", error: error)
    end
  end
end
