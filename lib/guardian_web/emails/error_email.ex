defmodule GuardianWeb.ErrorEmail do
  use GuardianWeb, :email

  alias Guardian.Errors.Error

  def new_error_email(%Error{} = error) do
    new_email(
      to: "juanandresvico8@gmail.com",
      from: "juanandresvico@hotmail.com",
      subject: "Attention!! New Error!",
      html_body: email_body(:new_error_email, :html, error: error),
      text_body: "Thanks for joining!"
    )
  end
end
