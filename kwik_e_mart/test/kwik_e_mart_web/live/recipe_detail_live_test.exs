defmodule KwikEMartWeb.RecipeDetailLiveTest do
  use KwikEMartWeb.ConnCase, async: false

  import Phoenix.LiveViewTest

  alias KwikEMart.{Offers, Recipes}

  setup do
    {:ok, cat} = Offers.create_category(%{name: "Apus Küche", slug: "apus-kueche-rd", type: "recipe"})

    {:ok, recipe} =
      Recipes.create_recipe(%{
        title: "Chicken Tikka Masala",
        description: "Ein leckeres Gericht aus Apus Heimat.",
        prep_time: 45,
        difficulty: "mittel",
        servings: 4,
        ingredients: ["Hähnchen", "Kokosmilch", "Tomaten"],
        instructions: "Alles zusammen kochen.",
        tags: ["indisch", "hähnchen"],
        category_id: cat.id
      })

    %{recipe: recipe}
  end

  test "rendert Rezept-Detailseite", %{conn: conn, recipe: recipe} do
    {:ok, _lv, html} = live(conn, ~p"/rezepte/live/#{recipe.id}")
    assert html =~ recipe.title
    assert html =~ "Zubereitung"
  end

  test "zeigt Zutaten", %{conn: conn, recipe: recipe} do
    {:ok, _lv, html} = live(conn, ~p"/rezepte/live/#{recipe.id}")
    assert html =~ "Hähnchen"
  end

  test "zeigt Schwierigkeitsgrad", %{conn: conn, recipe: recipe} do
    {:ok, _lv, html} = live(conn, ~p"/rezepte/live/#{recipe.id}")
    assert html =~ "mittel"
  end

  test "redirect bei nicht-existierender ID", %{conn: conn} do
    assert {:error, {:redirect, %{to: "/rezepte/live"}}} = live(conn, ~p"/rezepte/live/999999")
  end
end
