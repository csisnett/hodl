defmodule HodlWeb.Router do
  use HodlWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router, extensions: [PowResetPassword]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HodlWeb.Pow.Plug, otp_app: :hodl
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HodlWeb.Pow.Plug, otp_app: :hodl
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through [:browser]

    pow_routes()
    pow_extension_routes()
  end

  scope "/", HodlWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/new-schedule", PageController, :calculator
    get "/why-hodl", PageController, :why
    get "/plans", PageController, :plans
    get "/terms", PageController, :terms
    get "/privacy", PageController, :privacy
    get "/new-account", UserController, :new_account
    post "/create-account", UserController, :create_account


    resources "/alerts", QuoteAlertController, except: [:show, :edit, :update, :delete, :new, :create]
    get "/alerts/:uuid", QuoteAlertController, :show
    get "/alerts/:uuid/edit", QuoteAlertController, :edit
    put "/alerts/:uuid", QuoteAlertController, :update
    delete "/alerts/:uuid", QuoteAlertController, :delete
  end

  scope "/", HodlWeb do
    pipe_through [:browser, :protected]
    get "/new-alert", QuoteAlertController, :new
    resources "/coins", CoinController
  end

  scope "/", HodlWeb do
    pipe_through [:api]

    get "/user-alerts", QuoteAlertController, :my_alerts
    post "/alerts", QuoteAlertController, :create
  end

  scope "/", HodlWeb do
    pipe_through [:api]

    get "/top-coins", CoinController, :top_coins
    post "/quotes", QuoteController, :these_quotes
    post "/create-hodl", HodlscheduleController, :create
    
    get "/all-hodl", HodlscheduleController, :index
    get "/username-suggestion", PageController, :random_username
  end

  # Other scopes may use custom stacks.
  # scope "/api", HodlWeb do
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
      live_dashboard "/dashboard", metrics: HodlWeb.Telemetry
    end
  end
end
