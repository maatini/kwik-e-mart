defmodule KwikEMart.Recipes do
  import Ecto.Query

  alias KwikEMart.{Repo, Cache, Offers}
  alias KwikEMart.Recipes.Recipe

  def list_recipes(opts \\ []) do
    Cache.fetch_recipes(opts, fn -> do_list_recipes(opts) end)
  end

  defp do_list_recipes(opts) do
    category_id = Keyword.get(opts, :category_id)
    seasonal = Keyword.get(opts, :seasonal)
    tag = Keyword.get(opts, :tag)

    from(r in Recipe, preload: [:category], order_by: [asc: r.title])
    |> filter_by_category(category_id)
    |> filter_by_seasonal(seasonal)
    |> filter_by_tag(tag)
    |> Repo.all()
  end

  defp filter_by_category(query, nil), do: query
  defp filter_by_category(query, id), do: where(query, [r], r.category_id == ^id)

  defp filter_by_seasonal(query, nil), do: query
  defp filter_by_seasonal(query, val), do: where(query, [r], r.seasonal == ^val)

  defp filter_by_tag(query, nil), do: query
  defp filter_by_tag(query, tag), do: where(query, [r], ^tag in r.tags)

  def get_recipe!(id), do: Repo.get!(Recipe, id) |> Repo.preload(:category)

  def create_recipe(attrs) do
    result = %Recipe{} |> Recipe.changeset(attrs) |> Repo.insert()
    if match?({:ok, _}, result), do: Cache.invalidate_recipes()
    result
  end

  def update_recipe(%Recipe{} = recipe, attrs) do
    result = recipe |> Recipe.changeset(attrs) |> Repo.update()
    if match?({:ok, _}, result), do: Cache.invalidate_recipes()
    result
  end

  def delete_recipe(%Recipe{} = recipe) do
    result = Repo.delete(recipe)
    if match?({:ok, _}, result), do: Cache.invalidate_recipes()
    result
  end

  def list_seasonal_recipes do
    list_recipes(seasonal: true)
  end

  def list_categories, do: Offers.list_categories("recipe")

  def list_all_tags do
    Cache.fetch_tags(fn ->
      from(r in Recipe, select: fragment("DISTINCT UNNEST(?)", r.tags), order_by: [asc: 1])
      |> Repo.all()
    end)
  end
end
