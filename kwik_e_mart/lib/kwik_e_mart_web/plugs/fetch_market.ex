defmodule KwikEMartWeb.Plugs.FetchMarket do
  import Plug.Conn

  def init(opts), do: opts

  # Reads the kem_market_id cookie and writes it into the session so that
  # LiveViews can pick it up via session["market_id"] on mount.
  def call(conn, _opts) do
    case conn.cookies["kem_market_id"] do
      nil -> conn
      market_id -> put_session(conn, "market_id", String.to_integer(market_id))
    end
  end
end
