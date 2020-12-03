defmodule GuardianWeb.Plugs.EnsureAdminUser do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias Guardian.Accounts.User

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.assigns.current_user do
      %User{role: :admin} ->
        conn

      _ ->
        conn
        |> put_flash(:error, "You must be an admin to perform this action")
        |> redirect(to: "/")
        |> halt()
    end
  end
end
