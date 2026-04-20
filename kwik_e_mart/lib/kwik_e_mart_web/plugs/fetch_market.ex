defmodule KwikEMartWeb.Plugs.FetchMarket do
  import Plug.Conn

  def init(opts), do: opts

  # Reads the kem_market_id cookie and writes it into the session so that
  # LiveViews can pick it up via session["market_id"] on mount.
  def call(conn, _opts) do
    case conn.cookies["kem_market_id"] do
      nil ->
        conn

      market_id ->
        case Integer.parse(market_id) do
          {id, ""} -> put_session(conn, "market_id", id)
          _ -> conn
        end
    end
  end
end
