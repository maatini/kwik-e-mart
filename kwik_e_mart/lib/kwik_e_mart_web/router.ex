defmodule KwikEMartWeb.Router do
  use KwikEMartWeb, :router

  use Beacon.Router
  use Beacon.LiveAdmin.Router

  pipeline :beacon do
    plug Beacon.Plug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {KwikEMartWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin_auth do
    plug :basic_auth
  end

  defp basic_auth(conn, _opts) do
    username = Application.get_env(:kwik_e_mart, :admin_username, "admin")
    password = Application.get_env(:kwik_e_mart, :admin_password, "kwik_e_mart_admin")
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end

  # BeaconLiveAdmin – geschützt mit Basic Auth
  scope "/admin" do
    pipe_through [:browser, :admin_auth]
    beacon_live_admin("/")
  end

  # Custom LiveViews für interaktive Features
  scope "/", KwikEMartWeb do
    pipe_through :browser

    live "/markt-waehlen", MarketFinderLive, :index
    live "/angebote/live", OffersLive, :index
    live "/rezepte/live", RecipesLive, :index
  end

  if Application.compile_env(:kwik_e_mart, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: KwikEMartWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  # Beacon CMS – Kwik-E-Mart Site unter "/"
  scope "/", alias: KwikEMartWeb do
    pipe_through [:browser, :beacon]
    beacon_site("/", site: :kwik)
  end
end
