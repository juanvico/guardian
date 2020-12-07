defmodule GuardianWeb.ErrorEmail do
  use GuardianWeb, :email

  alias Guardian.Errors.Error

  def new_error_email(%Error{} = error, users) do
    new_email(
      to: Enum.map(users, & &1.email),
      from: "juanandresvico@hotmail.com",
      subject: "Attention!! New Error!",
      html_body: email_body(:new_error_email, :html, error: error)
    )
  end
end
