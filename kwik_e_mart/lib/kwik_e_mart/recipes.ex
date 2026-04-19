defmodule KwikEMart.Recipes do
  import Ecto.Query

  alias KwikEMart.{Repo, Cache}
  alias KwikEMart.Offers.Category
  alias KwikEMart.Recipes.Recipe

  @spec list_recipes(keyword()) :: [Recipe.t()]
  def list_recipes(opts \\ []) do
    Cache.fetch_recipes(opts, fn -> do_list_recipes(opts) end)
  end

  defp do_list_recipes(opts) do
    category_id = Keyword.get(opts, :category_id)
    seasonal = Keyword.get(opts, :seasonal)
    tag = Keyword.get(opts, :tag)
    limit = Keyword.get(opts, :limit)

    from(r in Recipe, preload: [:category], order_by: [asc: r.title])
    |> filter_by_category(category_id)
    |> filter_by_seasonal(seasonal)
    |> filter_by_tag(tag)
    |> then(fn q -> if limit, do: limit(q, ^limit), else: q end)
    |> Repo.all()
  end

  defp filter_by_category(query, nil), do: query
  defp filter_by_category(query, id), do: where(query, [r], r.category_id == ^id)

  defp filter_by_seasonal(query, nil), do: query
  defp filter_by_seasonal(query, val), do: where(query, [r], r.seasonal == ^val)

  defp filter_by_tag(query, nil), do: query
  defp filter_by_tag(query, tag), do: where(query, [r], ^tag in r.tags)

  @spec get_recipe!(pos_integer()) :: Recipe.t()
  def get_recipe!(id), do: Repo.get!(Recipe, id) |> Repo.preload(:category)

  @spec create_recipe(map()) :: {:ok, Recipe.t()} | {:error, Ecto.Changeset.t()}
  def create_recipe(attrs) do
    result = %Recipe{} |> Recipe.changeset(attrs) |> Repo.insert()
    if match?({:ok, _}, result), do: Cache.invalidate_recipes()
    result
  end

  @spec update_recipe(Recipe.t(), map()) :: {:ok, Recipe.t()} | {:error, Ecto.Changeset.t()}
  def update_recipe(%Recipe{} = recipe, attrs) do
    result = recipe |> Recipe.changeset(attrs) |> Repo.update()
    if match?({:ok, _}, result), do: Cache.invalidate_recipes()
    result
  end

  @spec delete_recipe(Recipe.t()) :: {:ok, Recipe.t()} | {:error, Ecto.Changeset.t()}
  def delete_recipe(%Recipe{} = recipe) do
    result = Repo.delete(recipe)
    if match?({:ok, _}, result), do: Cache.invalidate_recipes()
    result
  end

  @spec list_seasonal_recipes() :: [Recipe.t()]
  def list_seasonal_recipes do
    list_recipes(seasonal: true)
  end

  @spec list_categories() :: [KwikEMart.Offers.Category.t()]
  def list_categories do
    Cache.fetch_categories("recipe", fn ->
      from(c in Category, where: c.type == "recipe", order_by: [asc: c.name])
      |> Repo.all()
    end)
  end

  @spec list_all_tags() :: [String.t()]
  def list_all_tags do
    Cache.fetch_tags(fn ->
      from(r in Recipe, select: fragment("DISTINCT UNNEST(?)", r.tags), order_by: [asc: 1])
      |> Repo.all()
    end)
  end
end
