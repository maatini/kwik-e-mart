defmodule KwikEMart.RecipesTest do
  use KwikEMart.DataCase

  alias KwikEMart.{Recipes, Offers}
  alias KwikEMart.Recipes.Recipe

  setup do
    {:ok, category} =
      Offers.create_category(%{name: "Frühling", slug: "fruehling-test", type: "recipe"})

    %{category: category}
  end

  defp recipe_attrs(opts \\ []) do
    %{
      title: Keyword.get(opts, :title, "Testrezept"),
      description: "Ein leckeres Rezept",
      ingredients: ["Zutat 1", "Zutat 2"],
      prep_time: 30,
      tags: Keyword.get(opts, :tags, ["frühling"]),
      seasonal: Keyword.get(opts, :seasonal, false)
    }
  end

  describe "list_recipes/1" do
    test "gibt alle Rezepte zurück" do
      {:ok, recipe} = Recipes.create_recipe(recipe_attrs())
      recipes = Recipes.list_recipes()
      assert recipe.id in Enum.map(recipes, & &1.id)
    end

    test "filtert nach saisonal" do
      {:ok, _seasonal} = Recipes.create_recipe(recipe_attrs(seasonal: true))
      {:ok, _normal} = Recipes.create_recipe(recipe_attrs(title: "Normal", seasonal: false))

      seasonal = Recipes.list_recipes(seasonal: true)
      assert Enum.all?(seasonal, fn r -> r.seasonal == true end)
    end

    test "filtert nach Tag" do
      {:ok, _} = Recipes.create_recipe(recipe_attrs(tags: ["spargel", "frühling"]))
      {:ok, _} = Recipes.create_recipe(recipe_attrs(title: "Anderes", tags: ["winter"]))

      results = Recipes.list_recipes(tag: "spargel")
      assert Enum.all?(results, fn r -> "spargel" in r.tags end)
    end

    test "filtert nach Kategorie", %{category: cat} do
      {:ok, _} = Recipes.create_recipe(Map.put(recipe_attrs(), :category_id, cat.id))
      results = Recipes.list_recipes(category_id: cat.id)
      assert Enum.all?(results, fn r -> r.category_id == cat.id end)
    end
  end

  describe "create_recipe/1" do
    test "erstellt Rezept mit gültigen Attributen" do
      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe(recipe_attrs())
      assert recipe.title == "Testrezept"
      assert recipe.prep_time == 30
      assert recipe.seasonal == false
    end

    test "gibt Fehler bei fehlendem Titel" do
      assert {:error, changeset} = Recipes.create_recipe(%{})
      assert %{title: ["can't be blank"]} = errors_on(changeset)
    end

    test "gibt Fehler bei negativer Zubereitungszeit" do
      attrs = Map.put(recipe_attrs(), :prep_time, -5)
      assert {:error, changeset} = Recipes.create_recipe(attrs)
      assert %{prep_time: [_]} = errors_on(changeset)
    end
  end

  describe "list_seasonal_recipes/0" do
    test "gibt nur saisonale Rezepte zurück" do
      {:ok, _} = Recipes.create_recipe(recipe_attrs(seasonal: true))
      {:ok, _} = Recipes.create_recipe(recipe_attrs(title: "Normal", seasonal: false))

      seasonal = Recipes.list_seasonal_recipes()
      assert length(seasonal) >= 1
      assert Enum.all?(seasonal, fn r -> r.seasonal end)
    end
  end

  describe "update_recipe/2" do
    test "aktualisiert Rezept" do
      {:ok, recipe} = Recipes.create_recipe(recipe_attrs())
      assert {:ok, updated} = Recipes.update_recipe(recipe, %{title: "Neuer Titel"})
      assert updated.title == "Neuer Titel"
    end
  end

  describe "delete_recipe/1" do
    test "löscht Rezept" do
      {:ok, recipe} = Recipes.create_recipe(recipe_attrs())
      assert {:ok, _} = Recipes.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_recipe!(recipe.id) end
    end
  end
end
