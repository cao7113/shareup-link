defmodule SlinkWeb.Router do
  use SlinkWeb, :router
  import SlinkWeb.UserAuth
  import SlinkWeb.UserAgentTracer

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:trace_agent)
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

    # Regular Controller
    resources("/words", WordController)
    get("/test-redirect-to-live", LinkController, :test_to_live)

    # LiveView
    live("/test-live", TestLive, :test)
    live("/test-form-live", TestFormLive, :test)

    live_session :livings,
      on_mount: [{SlinkWeb.UserAuth, :mount_current_user}] do
      live("/", LinkLive.Index, :index)

      # links live
      live("/links", LinkLive.Index, :index)
      live("/links/new", LinkLive.Index, :new)
      live("/links/:id/edit", LinkLive.Index, :edit)
      live("/links/:id", LinkLive.Show, :show)
      live("/links/:id/show/edit", LinkLive.Show, :edit)

      live("/tags", TagLive.Index, :index)
      live("/tags/new", TagLive.Index, :new)
      live("/tags/:id/edit", TagLive.Index, :edit)
      live("/tags/:id", TagLive.Show, :show)
      live("/tags/:id/show/edit", TagLive.Show, :edit)
    end

    ## Page Controller
    get("/welcome", PageController, :home)
    get("/page", PageController, :index)
    get("/plain-page", PageController, :plain)
  end

  ############################################################
  ##                API

  scope "/api", SlinkWeb do
    pipe_through(:api)

    get("/", OpsController, :ping)
    get("/ping", OpsController, :ping)

    resources("/links", LinkController, except: [:new, :edit])
  end

  ## dev-tools

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

      get("/test", SlinkWeb.PageController, :test)
      get("/tailwind", SlinkWeb.PageController, :tailwind)
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
  use Kaffy.Routes,
    scope: "/admin",
    pipe_through: [
      :fetch_current_user,
      :require_authenticated_admin
    ]

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
