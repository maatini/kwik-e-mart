defmodule KwikEMartWeb.RecipesLiveTest do
  use KwikEMartWeb.ConnCase, async: false

  import Phoenix.LiveViewTest

  alias KwikEMart.{Recipes, Offers}

  setup do
    {:ok, cat} =
      Offers.create_category(%{name: "Apu's Küche", slug: "apus-kueche-lv", type: "recipe"})

    {:ok, recipe} =
      Recipes.create_recipe(%{
        title: "Apu's Tikka Masala",
        description: "Cremige Tomaten-Masala",
        ingredients: ["Hähnchen", "Kokosmilch"],
        prep_time: 45,
        tags: ["indisch"],
        seasonal: false,
        category_id: cat.id
      })

    {:ok, seasonal} =
      Recipes.create_recipe(%{
        title: "Saisonales Gericht",
        description: "Nur im Sommer",
        ingredients: ["Mango"],
        prep_time: 10,
        tags: ["sommer"],
        seasonal: true
      })

    %{category: cat, recipe: recipe, seasonal: seasonal}
  end

  test "rendert Seitenüberschrift", %{conn: conn} do
    {:ok, _lv, html} = live(conn, ~p"/rezepte/live")
    assert html =~ "Rezepte &amp; Inspiration"
  end

  test "zeigt alle Rezepte beim Start", %{conn: conn} do
    {:ok, _lv, html} = live(conn, ~p"/rezepte/live")
    # Apostroph wird als &#39; gerendert – partiellen Titel prüfen
    assert html =~ "Tikka Masala"
    assert html =~ "Saisonales Gericht"
  end

  test "Saisonal-Filter zeigt nur saisonale Rezepte", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/rezepte/live")

    html = lv |> element("[phx-click='toggle_seasonal']") |> render_click()
    assert html =~ "Saisonales Gericht"
    refute html =~ "Tikka Masala"
  end

  test "Kategorie-Filter zeigt nur Rezepte der Kategorie", %{conn: conn, category: cat} do
    {:ok, lv, _html} = live(conn, ~p"/rezepte/live")

    html =
      lv |> element("[phx-click='filter_category'][phx-value-id='#{cat.id}']") |> render_click()

    assert html =~ "Tikka Masala"
    refute html =~ "Saisonales Gericht"
  end

  test "Filter zurücksetzen zeigt alle Rezepte", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/rezepte/live")

    lv |> element("[phx-click='toggle_seasonal']") |> render_click()
    html = lv |> element("[phx-click='reset_filter']") |> render_click()
    assert html =~ "Tikka Masala"
    assert html =~ "Saisonales Gericht"
  end
end
