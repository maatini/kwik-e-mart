defmodule KwikEMart.Cache do
  @cache :kwik_cache

  @offers_ttl :timer.minutes(5)
  @recipes_ttl :timer.minutes(5)
  @categories_ttl :timer.hours(1)

  def fetch_offers(opts, fun),
    do: fetch({:offers, :erlang.phash2(opts)}, @offers_ttl, fun)

  def fetch_featured_offers(limit, fun),
    do: fetch({:offers, :featured, limit}, @offers_ttl, fun)

  def fetch_recipes(opts, fun),
    do: fetch({:recipes, :erlang.phash2(opts)}, @recipes_ttl, fun)

  def fetch_tags(fun),
    do: fetch({:recipes, :tags}, @recipes_ttl, fun)

  def fetch_categories(type, fun),
    do: fetch({:categories, type}, @categories_ttl, fun)

  def invalidate_offers, do: invalidate_prefix(:offers)
  def invalidate_recipes, do: invalidate_prefix(:recipes)

  defp fetch(key, ttl, fun) do
    if Application.get_env(:kwik_e_mart, :cache_enabled, true) do
      case Cachex.fetch(@cache, key, fn -> {:commit, fun.(), [ttl: ttl]} end) do
        {:ok, value} -> value
        {:loaded, value} -> value
        _ -> fun.()
      end
    else
      fun.()
    end
  end

  defp invalidate_prefix(prefix) do
    with {:ok, keys} <- Cachex.keys(@cache) do
      keys
      |> Enum.filter(&(is_tuple(&1) and elem(&1, 0) == prefix))
      |> Enum.each(&Cachex.del(@cache, &1))
    end

    :ok
  end
end
