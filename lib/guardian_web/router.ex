defmodule GuardianWeb.Router do
  use GuardianWeb, :router

  import GuardianWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GuardianWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :ensure_browser_authenticated do
    plug GuardianWeb.Plugs.EnsureAuthenticated
  end

  pipeline :ensure_api_application_authenticated do
    plug GuardianWeb.Plugs.EnsureApiApplicationAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GuardianWeb do
    get "/health", HealthController, :show
  end

  scope "/", GuardianWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  scope "/api/v1", GuardianWeb.Api.V1, as: :api_v1 do
    pipe_through [:api, :ensure_api_application_authenticated]

    resources "/errors", ErrorController, only: [:create, :index]
  end

  scope "/admin", GuardianWeb.Admin, as: :admin do
    pipe_through [:browser, :ensure_browser_authenticated]

    resources "/errors", ErrorController
    resources "/invitations", InvitationController, except: [:edit, :update]
    resources "/application_keys", ApplicationKeyController
  end

  # Other scopes may use custom stacks.
  # scope "/api", GuardianWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: GuardianWeb.Telemetry
    end

    # preview emails
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  ## Authentication routes

  scope "/", GuardianWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", GuardianWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_email", UserSettingsController, :update_email
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", GuardianWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm

    get "/invitations/:token/accept", AcceptedInvitationController, :new
    post "/accept_invitation", AcceptedInvitationController, :create
  end
end
