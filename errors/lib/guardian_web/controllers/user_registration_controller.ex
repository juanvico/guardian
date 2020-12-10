defmodule GuardianWeb.UserRegistrationController do
  use GuardianWeb, :controller

  alias Guardian.Accounts
  alias Guardian.Accounts.User
  alias GuardianWeb.UserAuth
  alias GuardianWeb.Queue

  @topic_user_add "users_add"

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    %{"organization" => organization_params} = user_params

    case Accounts.register_user(user_params, organization_params || %{}) do
      {:ok, user} ->
        reportNewUserToOrg(user.organization)

        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp reportNewUserToOrg(organization) do
    Queue.publish(@topic_user_add, Jason.encode!(%{
      "org_id" => organization.id
    }))
  end
end
