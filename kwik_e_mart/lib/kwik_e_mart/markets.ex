defmodule KwikEMart.Markets do
  import Ecto.Query

  alias KwikEMart.Repo
  alias KwikEMart.Markets.Market

  def list_markets do
    Repo.all(from m in Market, order_by: [asc: m.city, asc: m.name])
  end

  def list_markets_by_city(city) do
    Repo.all(from m in Market, where: ilike(m.city, ^"%#{city}%"), order_by: m.name)
  end

  def list_markets_by_zip(zip) do
    Repo.all(from m in Market, where: m.zip == ^zip)
  end

  def list_markets_by_region(region) do
    Repo.all(from m in Market, where: m.region == ^region, order_by: m.city)
  end

  def get_market!(id), do: Repo.get!(Market, id)

  def get_market(id), do: Repo.get(Market, id)

  def create_market(attrs) do
    %Market{}
    |> Market.changeset(attrs)
    |> Repo.insert()
  end

  def update_market(%Market{} = market, attrs) do
    market
    |> Market.changeset(attrs)
    |> Repo.update()
  end

  def delete_market(%Market{} = market), do: Repo.delete(market)

  def search_markets(query) when byte_size(query) >= 2 do
    q = "%#{query}%"

    Repo.all(
      from m in Market,
        where: ilike(m.city, ^q) or ilike(m.zip, ^q) or ilike(m.name, ^q),
        order_by: [asc: m.city],
        limit: 20
    )
  end

  def search_markets(_), do: []

  def find_nearby_markets(lat, lng, radius_km \\ 25) do
    Repo.all(
      from m in Market,
        where: not is_nil(m.latitude) and not is_nil(m.longitude),
        order_by:
          fragment(
            "((? - ?)^2 + (? - ?)^2)",
            m.latitude,
            ^lat,
            m.longitude,
            ^lng
          ),
        limit: 10
    )
    |> Enum.filter(fn m ->
      distance_km(m.latitude, m.longitude, lat, lng) <= radius_km
    end)
  end

  defp distance_km(lat1, lon1, lat2, lon2) do
    r = 6371
    dlat = (lat2 - lat1) * :math.pi() / 180
    dlon = (lon2 - lon1) * :math.pi() / 180
    a = :math.sin(dlat / 2) ** 2 + :math.cos(lat1 * :math.pi() / 180) * :math.cos(lat2 * :math.pi() / 180) * :math.sin(dlon / 2) ** 2
    c = 2 * :math.atan2(:math.sqrt(a), :math.sqrt(1 - a))
    r * c
  end
end
