defmodule Get5ApiWeb.Router do
  use Get5ApiWeb, :router

  import Get5ApiWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_root_layout, {Get5ApiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Get5ApiWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/", Get5ApiWeb do
    pipe_through [:browser]

    live_session :authenticated,
      on_mount: [{Get5ApiWeb.UserAuth, :ensure_authenticated}] do
      live "/matches", MatchLive.Index, :index
      live "/matches/new", MatchLive.Index, :new
      live "/matches/:id/edit", MatchLive.Index, :edit

      live "/matches/:id", MatchLive.Show, :show
      live "/matches/:id/show/edit", MatchLive.Show, :edit

      live "/game_servers", GameServerLive.Index, :index
      live "/game_servers/new", GameServerLive.Index, :new
      live "/game_servers/:id/edit", GameServerLive.Index, :edit

      live "/game_servers/:id", GameServerLive.Show, :show
      live "/game_servers/:id/show/edit", GameServerLive.Show, :edit

      live "/teams", TeamLive.Index, :index
      live "/teams/new", TeamLive.Index, :new
      live "/teams/:id/edit", TeamLive.Index, :edit

      live "/teams/:id", TeamLive.Show, :show
      live "/teams/:id/show/edit", TeamLive.Show, :edit
      live "/teams/:id/players/new", TeamLive.Show, :add_player
    end
  end

  scope "/", Get5ApiWeb do
    pipe_through :api
    get "/matches/:id/match-config", MatchController, :match_config
    post "/matches/:id/series-start", MatchController, :series_start
  end

  scope "/" do
    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: Get5ApiWeb.Schema,
      interface: :simple,
      context: %{pubsub: Get5ApiWeb.Endpoint}
  end

  scope "/api" do
    forward "/graphql/v1", Absinthe.Plug, schema: Get5ApiWeb.Schema
  end

  scope "/auth", Get5ApiWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:get5_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Get5ApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", Get5ApiWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{Get5ApiWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", Get5ApiWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{Get5ApiWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", Get5ApiWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{Get5ApiWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
