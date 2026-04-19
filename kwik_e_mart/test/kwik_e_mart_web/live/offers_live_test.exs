defmodule KwikEMartWeb.OffersLiveTest do
  use KwikEMartWeb.ConnCase, async: false

  import Phoenix.LiveViewTest

  alias KwikEMart.{Markets, Offers}

  setup do
    {:ok, market} =
      Markets.create_market(%{
        name: "Kwik-E-Mart Test",
        city: "Springfield",
        zip: "58008",
        street: "1 Test St"
      })

    {:ok, cat} = Offers.create_category(%{name: "Getränke", slug: "getraenke-lv", type: "offer"})

    today = Date.utc_today()

    {:ok, offer} =
      Offers.create_offer(%{
        title: "Duff Beer",
        price: "4.99",
        valid_from: today,
        valid_to: Date.add(today, 7),
        market_id: market.id,
        category_id: cat.id,
        discount_percent: 20
      })

    %{market: market, category: cat, offer: offer}
  end

  test "rendert Seitenüberschrift", %{conn: conn} do
    {:ok, _lv, html} = live(conn, ~p"/angebote/live")
    assert html =~ "Wochenangebote"
  end

  test "zeigt Kategoriefilter", %{conn: conn, category: cat} do
    {:ok, _lv, html} = live(conn, ~p"/angebote/live")
    assert html =~ cat.name
  end

  test "Kategorie-Filter schränkt Angebote ein", %{conn: conn, category: cat, offer: offer} do
    {:ok, lv, _html} = live(conn, ~p"/angebote/live")

    html = lv |> element("[phx-click='filter_category'][phx-value-id='#{cat.id}']") |> render_click()
    assert html =~ offer.title
  end

  test "Filter zurücksetzen zeigt alle Angebote", %{conn: conn, offer: offer} do
    {:ok, lv, _html} = live(conn, ~p"/angebote/live")

    lv |> element("[phx-click='reset_filter']") |> render_click()
    html = render(lv)
    assert html =~ offer.title
  end

  test "leere Angebotsliste zeigt Hinweis wenn kein Markt und kein Angebot passt",
       %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/angebote/live?category=999999")
    html = render(lv)
    assert html =~ "Keine Angebote gefunden"
  end
end
