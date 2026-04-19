defmodule KwikEMartWeb.HomeLiveTest do
  use KwikEMartWeb.ConnCase, async: false

  import Phoenix.LiveViewTest

  alias KwikEMart.{Offers, Recipes}

  setup do
    today = Date.utc_today()

    {:ok, cat_offer} = Offers.create_category(%{name: "Getränke", slug: "getraenke-hl", type: "offer"})
    {:ok, cat_recipe} = Recipes.list_categories() |> case do
      [] ->
        Offers.create_category(%{name: "Apus Küche", slug: "apus-kueche-hl", type: "recipe"})
      [c | _] ->
        {:ok, c}
    end

    {:ok, offer} =
      Offers.create_offer(%{
        title: "Duff Beer Featured",
        price: "3.99",
        original_price: "5.99",
        discount_percent: 34,
        valid_from: today,
        valid_to: Date.add(today, 6),
        category_id: cat_offer.id
      })

    {:ok, recipe} =
      Recipes.create_recipe(%{
        title: "Apu's Tikka Masala",
        prep_time: 30,
        difficulty: "mittel",
        category_id: cat_recipe.id
      })

    %{offer: offer, recipe: recipe}
  end

  test "rendert Homepage", %{conn: conn} do
    {:ok, _lv, html} = live(conn, ~p"/")
    assert html =~ "Kwik-E-Mart"
  end

  test "zeigt Featured Offers", %{conn: conn, offer: offer} do
    {:ok, _lv, html} = live(conn, ~p"/")
    assert html =~ offer.title
  end

  test "zeigt maximal 3 Rezepte", %{conn: conn} do
    {:ok, cat} = Offers.create_category(%{name: "Schnell", slug: "schnell-hl2", type: "recipe"})

    for i <- 1..5 do
      Recipes.create_recipe(%{
        title: "Rezept #{i}",
        prep_time: 10,
        difficulty: "leicht",
        category_id: cat.id
      })
    end

    {:ok, _lv, html} = live(conn, ~p"/")
    recipe_count = html |> String.split(~s(class="recipe-card group")) |> length() |> Kernel.-(1)
    assert recipe_count <= 3
  end

  test "Newsletter-Subscription: Erfolgsmeldung bei gültiger E-Mail", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/")

    html =
      lv
      |> form("form[phx-submit='subscribe_newsletter']", %{email: "bart@simpsons.com"})
      |> render_submit()

    assert html =~ "Danke"
    assert html =~ "bart@simpsons.com"
  end

  test "Newsletter-Subscription: Fehler bei leerer E-Mail", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/")

    html =
      lv
      |> form("form[phx-submit='subscribe_newsletter']", %{email: ""})
      |> render_submit()

    assert html =~ "gültige E-Mail"
  end
end
