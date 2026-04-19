defmodule KwikEMart.Markets do
  import Ecto.Query

  alias KwikEMart.Repo
  alias KwikEMart.Markets.Market

  @spec list_markets() :: [Market.t()]
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

  @spec get_market!(pos_integer()) :: Market.t()
  def get_market!(id), do: Repo.get!(Market, id)

  @spec get_market(pos_integer()) :: Market.t() | nil
  def get_market(id), do: Repo.get(Market, id)

  @spec create_market(map()) :: {:ok, Market.t()} | {:error, Ecto.Changeset.t()}
  def create_market(attrs) do
    %Market{}
    |> Market.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_market(Market.t(), map()) :: {:ok, Market.t()} | {:error, Ecto.Changeset.t()}
  def update_market(%Market{} = market, attrs) do
    market
    |> Market.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_market(Market.t()) :: {:ok, Market.t()} | {:error, Ecto.Changeset.t()}
  def delete_market(%Market{} = market), do: Repo.delete(market)

  @spec search_markets(String.t()) :: [Market.t()]
  def search_markets(query) when byte_size(query) >= 2 do
    escaped = String.replace(query, ~r/[%_\\]/, "\\\\\\0")
    q = "%#{escaped}%"

    Repo.all(
      from m in Market,
        where: ilike(m.city, ^q) or ilike(m.zip, ^q) or ilike(m.name, ^q),
        order_by: [asc: m.city],
        limit: 20
    )
  end

  def search_markets(_), do: []

  @spec find_nearby_markets(float(), float(), number()) :: [Market.t()]
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
