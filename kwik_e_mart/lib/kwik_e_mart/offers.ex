defmodule KwikEMart.Offers do
  import Ecto.Query

  alias KwikEMart.Repo
  alias KwikEMart.Offers.{Offer, Category}

  def list_offers(opts \\ []) do
    market_id = Keyword.get(opts, :market_id)
    category_id = Keyword.get(opts, :category_id)
    superknueller = Keyword.get(opts, :superknueller, false)
    today = Date.utc_today()

    from(o in Offer,
      where: o.valid_from <= ^today and o.valid_to >= ^today,
      preload: [:category, :market],
      order_by: [desc: o.discount_percent]
    )
    |> filter_by_market(market_id)
    |> filter_by_category(category_id)
    |> filter_by_superknueller(superknueller)
    |> Repo.all()
  end

  defp filter_by_market(query, nil), do: query
  defp filter_by_market(query, id), do: where(query, [o], o.market_id == ^id)

  defp filter_by_category(query, nil), do: query
  defp filter_by_category(query, id), do: where(query, [o], o.category_id == ^id)

  defp filter_by_superknueller(query, false), do: query
  defp filter_by_superknueller(query, true), do: where(query, [o], o.discount_percent >= 30)

  def list_featured_offers(limit \\ 6) do
    today = Date.utc_today()

    from(o in Offer,
      where: o.valid_from <= ^today and o.valid_to >= ^today and o.discount_percent >= 25,
      preload: [:category, :market],
      order_by: [desc: o.discount_percent],
      limit: ^limit
    )
    |> Repo.all()
  end

  def get_offer!(id), do: Repo.get!(Offer, id) |> Repo.preload([:market, :category])

  def create_offer(attrs) do
    %Offer{}
    |> Offer.changeset(attrs)
    |> Repo.insert()
  end

  def update_offer(%Offer{} = offer, attrs) do
    offer
    |> Offer.changeset(attrs)
    |> Repo.update()
  end

  def delete_offer(%Offer{} = offer), do: Repo.delete(offer)

  # Categories
  def list_categories(type \\ "offer") do
    Repo.all(from c in Category, where: c.type == ^type, order_by: c.name)
  end

  def get_category!(id), do: Repo.get!(Category, id)

  def create_category(attrs) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end
end
