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
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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
    get "/new-hodl", PageController, :calculator
  end

  scope "/", HodlWeb do
    pipe_through [:api]

    get "/top-coins", CoinController, :top_coins
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
