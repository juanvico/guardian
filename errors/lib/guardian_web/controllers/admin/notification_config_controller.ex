defmodule GuardianWeb.Admin.NotificationConfigController do
  use GuardianWeb, :controller

  alias Guardian.NotificationConfigAdmin
  alias GuardianWeb.Queue

  @topic_configure_user "configure_user"

  plug(:put_root_layout, {GuardianWeb.LayoutView, "torch.html"})

  def create(
        conn,
        params,
        current_user
      ) do
    config = params["config"]
    reportUserConfiguration(current_user, config)
    render(conn, "index.html", %{config: config, error: false})
  end

  def index(conn, _params, current_user) do
    configuration_response = NotificationConfigAdmin.get_configuration(current_user)

    if configuration_response == {:error} do
      render(conn, "index.html", %{invoice: nil, error: true})
    else
      {:ok, configuration} = configuration_response
      render(conn, "index.html", %{config: configuration["configuration"], error: false})
    end
  end

  defp reportUserConfiguration(user, config) do
    Queue.publish(
      @topic_configure_user,
      Jason.encode!(%{
        "user_id" => user.id,
        "severity_filter" => config["severity_filter"],
        "immediate_notification" => config["immediate_notification"],
        "daily_notification" => config["daily_notification"],
        "daily_notification_time" => config["daily_notification_time"]
      })
    )
  end
end
