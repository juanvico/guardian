defmodule GuardianWeb.ErrorsEmail do
  import Bamboo.Email
  alias Guardian.Errors.Error

  def new_error_email(error) do
    new_email(
      to: "juanandresvico8@gmail.com",
      from: "juanandresvico@hotmail.com",
      subject: "Attention!! New Error!",
      html_body: new_error_email_body(error),
      text_body: "Thanks for joining!"
    )
  end

  defp new_error_email_body(%Error{
         title: title,
         description: description,
         severity: severity
       }) do
    ~s{
        <strong style="font-size: 20px">
          Title:
        </strong>
        <p style="font-size: 20px">
          #{title}
        </p>
        <strong style="font-size: 20px">
          Description:
        </strong>
        <p style="font-size: 20px">
          #{description}
        </p>
        <strong style="font-size: 20px">
          Severity:
        </strong>
        <p style="font-size: 20px">
          #{severity}
        </p>
      }
  end
end
