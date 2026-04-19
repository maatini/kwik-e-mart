defmodule KwikEMart.Recipes do
  import Ecto.Query

  alias KwikEMart.Repo
  alias KwikEMart.Recipes.Recipe

  def list_recipes(opts \\ []) do
    category_id = Keyword.get(opts, :category_id)
    seasonal = Keyword.get(opts, :seasonal)
    tag = Keyword.get(opts, :tag)

    from(r in Recipe, preload: [:category], order_by: [desc: r.inserted_at])
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
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  def delete_recipe(%Recipe{} = recipe), do: Repo.delete(recipe)

  def list_seasonal_recipes do
    list_recipes(seasonal: true)
  end

  def list_all_tags do
    from(r in Recipe, select: fragment("DISTINCT UNNEST(?)", r.tags), order_by: [asc: 1])
    |> Repo.all()
  end
end
