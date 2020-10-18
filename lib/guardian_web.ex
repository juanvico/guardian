defmodule GuardianWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use GuardianWeb, :controller
      use GuardianWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: GuardianWeb

      import Plug.Conn
      alias Plug.Conn
      import GuardianWeb.Gettext
      alias GuardianWeb.Router.Helpers, as: Routes

      def action(conn, _) do
        args =
          if function_exported?(__MODULE__, action_name(conn), 3) do
            [conn, conn.params, conn.assigns.current_user]
          else
            [conn, conn.params]
          end

        apply(__MODULE__, action_name(conn), args)
      end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/guardian_web/templates",
        namespace: GuardianWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {GuardianWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def email do
    quote do
      use Phoenix.View,
        root: "lib/guardian_web/templates/emails",
        namespace: GuardianWeb

      import Bamboo.Email

      unquote(view_helpers())

      def email_body(name, format, assigns) when format in [:html, :text] do
        render_to_string(__MODULE__, "#{Atom.to_string(name)}.#{Atom.to_string(format)}", assigns)
      end
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import GuardianWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import GuardianWeb.ErrorHelpers
      import GuardianWeb.Gettext
      alias GuardianWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
