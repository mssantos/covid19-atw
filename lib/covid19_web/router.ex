defmodule Covid19Web.Router do
  use Covid19Web, :router
  import Plug.BasicAuth
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Covid19Web.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    if Mix.env() == :prod do
      plug :basic_auth, username: System.get_env("DASHBOARD_USERNAME"), password: System.get_env("DASHBOARD_PASSWORD")
    end
  end

  scope "/", Covid19Web do
    pipe_through :browser

    live "/", WorldwideLive, :index
  end

  scope "/" do
    pipe_through [:browser, :auth]
    live_dashboard "/dashboard", metrics: Covid19Web.Telemetry
  end
end
