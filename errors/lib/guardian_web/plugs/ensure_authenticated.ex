defmodule GuardianWeb.Plugs.EnsureAuthenticated do
  @moduledoc """
  Sets the current user for an authenticated request
  in the connection
  """

  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  alias GuardianWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.assigns.current_user do
      nil ->
        conn
        |> put_flash(:error, "You must be authenticated in to access that page")
        |> redirect(to: Routes.user_session_path(conn, :new))
        |> halt()

      _user ->
        conn
    end
  end
end
