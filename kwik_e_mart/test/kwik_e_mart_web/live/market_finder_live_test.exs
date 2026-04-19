defmodule KwikEMartWeb.MarketFinderLiveTest do
  use KwikEMartWeb.ConnCase, async: false

  import Phoenix.LiveViewTest

  alias KwikEMart.Markets

  @market_attrs %{
    name: "Kwik-E-Mart Springfield",
    city: "Springfield",
    zip: "58008",
    street: "742 Evergreen Terrace",
    region: "Springfield County"
  }

  setup do
    {:ok, market} = Markets.create_market(@market_attrs)
    %{market: market}
  end

  test "rendert Seitenüberschrift", %{conn: conn} do
    {:ok, _lv, html} = live(conn, ~p"/markt-waehlen")
    assert html =~ "Deinen Kwik-E-Mart finden"
  end

  test "Suche nach Stadt liefert Treffer", %{conn: conn, market: _market} do
    {:ok, lv, _html} = live(conn, ~p"/markt-waehlen")

    html = lv |> element("form") |> render_change(%{"query" => "Springfield"})
    assert html =~ "Kwik-E-Mart Springfield"
  end

  test "leere Suche zeigt keine Ergebnisse", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/markt-waehlen")

    html = lv |> element("form") |> render_change(%{"query" => ""})
    refute html =~ "phx-value-id"
  end

  test "Markt auswählen zeigt Flash-Meldung", %{conn: conn, market: market} do
    {:ok, lv, _html} = live(conn, ~p"/markt-waehlen")

    lv |> element("form") |> render_change(%{"query" => "Springfield"})
    html = lv |> element("[phx-click='select_market']") |> render_click()

    assert html =~ market.name
  end

  test "Kein Treffer bei unbekannter Stadt zeigt Hinweis", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/markt-waehlen")

    html = lv |> element("form") |> render_change(%{"query" => "Nichtexistierend"})
    assert html =~ "Kein Markt gefunden"
  end
end
