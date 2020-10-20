defmodule GuardianWeb.Api.V1.ErrorController do
  use GuardianWeb, :controller

  alias Guardian.Errors
  alias Guardian.Errors.Error
  alias GuardianWeb.Mailer
  alias GuardianWeb.ErrorEmail

  action_fallback GuardianWeb.FallbackController

  def index(conn, _, application_key) do
    errors = Errors.list_most_critical_errors(application_key.organization)
    
    render(conn, "index.json", errors: errors)
  end

  def create(conn, %{"error" => error_params}, application_key) do
    with {:ok, %Error{} = error} <-
           Errors.create_error(application_key.organization, error_params) do
      ErrorEmail.new_error_email(error)
      |> Mailer.deliver_now()

      conn
      |> put_status(:created)
      |> render("show.json", error: error)
    end
  end
end
