defmodule SlinkWeb.Router do
  use SlinkWeb, :router
  import SlinkWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {SlinkWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SlinkWeb do
    pipe_through(:browser)

    live("/", LinkLive.Index, :index)

    get("/welcome", PageController, :home)
    get "/page", PageController, :index
    get("/plain-page", PageController, :plain)

    # normal words with controller
    resources("/words", WordController)

    get("/test-redirect-to-live", LinkController, :test_to_live)

    # Living
    live "/test-live", TestLive, :test
    live "/test-form-live", TestFormLive, :test

    # links live
    live("/links", LinkLive.Index, :index)
    live("/links/new", LinkLive.Index, :new)
    live("/links/:id/edit", LinkLive.Index, :edit)
    live("/links/:id", LinkLive.Show, :show)
    live("/links/:id/show/edit", LinkLive.Show, :edit)
  end

  ############################################################
  ##                API

  scope "/api", SlinkWeb do
    pipe_through(:api)

    get("/", OpsController, :ping)
    get("/ping", OpsController, :ping)

    resources("/links", LinkController, except: [:new, :edit])
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:slink, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: SlinkWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", SlinkWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{SlinkWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live("/users/register", UserRegistrationLive, :new)
      live("/users/log_in", UserLoginLive, :new)
      live("/users/reset_password", UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", UserResetPasswordLive, :edit)
    end

    post("/users/log_in", UserSessionController, :create)
  end

  scope "/", SlinkWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user,
      on_mount: [{SlinkWeb.UserAuth, :ensure_authenticated}] do
      live("/users/settings", UserSettingsLive, :edit)
      live("/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email)
    end
  end

  scope "/", SlinkWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)

    live_session :current_user,
      on_mount: [{SlinkWeb.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
    end
  end

  ## Kaffy Admin routes

  # use Kaffy.Routes, scope: "/admin", pipe_through: [:some_plug, :authenticate]
  use Kaffy.Routes, scope: "/admin", pipe_through: []
  # :scope defaults to "/admin"
  # :pipe_through defaults to kaffy's [:kaffy_browser]
  # when providing pipelines, they will be added after :kaffy_browser
  # so the actual pipe_through for the previous line is:
  # [:kaffy_browser, :some_plug, :authenticate]
  # pipeline :kaffy_browser do
  #   plug :accepts, ["html", "json"]
  #   plug :fetch_session
  #   plug :fetch_flash
  #   plug :protect_from_forgery
  #   plug :put_secure_browser_headers
  # end
end
