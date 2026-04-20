defmodule KwikEMart.Offers do
  import Ecto.Query
  require Logger

  alias KwikEMart.{Repo, Cache}
  alias KwikEMart.Offers.{Offer, Category}

  NimbleCSV.define(KwikEMart.Offers.CSV, separator: ",", escape: "\"")

  # ---------------------------------------------------------------------------
  # Offers
  # ---------------------------------------------------------------------------

  @spec list_offers(keyword()) :: [Offer.t()]
  def list_offers(opts \\ []) do
    Cache.fetch_offers(opts, fn -> do_list_offers(opts) end)
  end

  defp do_list_offers(opts) do
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

  @spec list_featured_offers(pos_integer()) :: [Offer.t()]
  def list_featured_offers(limit \\ 6) do
    Cache.fetch_featured_offers(limit, fn ->
      today = Date.utc_today()

      from(o in Offer,
        where: o.valid_from <= ^today and o.valid_to >= ^today and o.discount_percent >= 25,
        preload: [:category, :market],
        order_by: [desc: o.discount_percent],
        limit: ^limit
      )
      |> Repo.all()
    end)
  end

  @spec get_offer!(pos_integer()) :: Offer.t()
  def get_offer!(id), do: Repo.get!(Offer, id) |> Repo.preload([:market, :category])

  @spec create_offer(map()) :: {:ok, Offer.t()} | {:error, Ecto.Changeset.t()}
  def create_offer(attrs) do
    result = %Offer{} |> Offer.changeset(attrs) |> Repo.insert()
    if match?({:ok, _}, result), do: Cache.invalidate_offers()
    result
  end

  @spec update_offer(Offer.t(), map()) :: {:ok, Offer.t()} | {:error, Ecto.Changeset.t()}
  def update_offer(%Offer{} = offer, attrs) do
    result = offer |> Offer.changeset(attrs) |> Repo.update()
    if match?({:ok, _}, result), do: Cache.invalidate_offers()
    result
  end

  @spec delete_offer(Offer.t()) :: {:ok, Offer.t()} | {:error, Ecto.Changeset.t()}
  def delete_offer(%Offer{} = offer) do
    result = Repo.delete(offer)
    if match?({:ok, _}, result), do: Cache.invalidate_offers()
    result
  end

  # ---------------------------------------------------------------------------
  # Weekly CSV Import
  # ---------------------------------------------------------------------------

  @doc """
  Imports weekly offers from a CSV file.

  Sets valid_from = today, valid_to = today + 6.
  Existing offers are not deleted — date-based filtering handles expiry naturally.

  Returns {:ok, count} or {:error, reason}.

  CSV columns: title,description,price,original_price,discount_percent,category_slug,featured,image_url
  """
  @spec import_weekly_offers(String.t()) :: {:ok, non_neg_integer()} | {:error, term()}
  def import_weekly_offers(path \\ default_import_path()) do
    Logger.info("[KwikEMart] Loading this week's offers from #{path}...")

    with {:ok, content} <- File.read(path),
         {:ok, rows} <- parse_csv(content),
         {:ok, count} <- insert_offers(rows) do
      Logger.info("[KwikEMart] #{count} Angebote importiert. Thank you, come again!")
      {:ok, count}
    else
      {:error, reason} ->
        Logger.error("[KwikEMart] Import fehlgeschlagen: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp default_import_path do
    Application.app_dir(:kwik_e_mart, "priv/import/current_week.csv")
  end

  defp parse_csv(content) do
    rows =
      content
      |> KwikEMart.Offers.CSV.parse_string(skip_headers: true)
      |> Enum.map(fn [
                       title,
                       description,
                       price,
                       original_price,
                       discount_percent,
                       category_slug,
                       featured,
                       image_url
                     ] ->
        %{
          title: title,
          description: description,
          price: price,
          original_price: original_price,
          discount_percent: discount_percent,
          category_slug: category_slug,
          featured: featured == "true",
          image_url: image_url
        }
      end)

    {:ok, rows}
  rescue
    e -> {:error, "CSV-Parsing fehlgeschlagen: #{Exception.message(e)}"}
  end

  defp insert_offers(rows) do
    today = Date.utc_today()
    valid_from = today
    valid_to = Date.add(today, 6)

    multi =
      rows
      |> Enum.with_index()
      |> Enum.reduce(Ecto.Multi.new(), fn {row, idx}, multi ->
        attrs = build_offer_attrs(row, valid_from, valid_to)
        changeset = %Offer{} |> Offer.changeset(attrs)
        Ecto.Multi.insert(multi, {:offer, idx}, changeset)
      end)

    case Repo.transaction(multi) do
      {:ok, results} ->
        Cache.invalidate_offers()
        {:ok, map_size(results)}

      {:error, {:offer, idx}, changeset, _changes} ->
        row_title = rows |> Enum.at(idx) |> Map.get(:title, "?")

        Logger.warning(
          "[KwikEMart] Import fehlgeschlagen bei '#{row_title}': #{inspect(changeset.errors)}"
        )

        {:error, changeset}
    end
  end

  defp build_offer_attrs(row, valid_from, valid_to) do
    %{
      title: row.title,
      description: row.description,
      price: parse_decimal(row.price),
      original_price: parse_decimal(row.original_price),
      discount_percent: parse_integer(row.discount_percent),
      image_url: row.image_url,
      valid_from: valid_from,
      valid_to: valid_to,
      category_id: get_category_id_by_slug(row.category_slug)
    }
  end

  defp get_category_id_by_slug(slug) when is_binary(slug) and slug != "" do
    case Repo.get_by(Category, slug: slug, type: "offer") do
      %Category{id: id} ->
        id

      nil ->
        Logger.warning("[KwikEMart] Kategorie '#{slug}' nicht gefunden - Angebot ohne Kategorie")
        nil
    end
  end

  defp get_category_id_by_slug(_), do: nil

  defp parse_decimal(""), do: nil

  defp parse_decimal(s) do
    case Decimal.parse(String.trim(s)) do
      {d, ""} -> d
      _ -> nil
    end
  end

  defp parse_integer(""), do: nil

  defp parse_integer(s) do
    case Integer.parse(String.trim(s)) do
      {i, _} -> i
      :error -> nil
    end
  end

  # ---------------------------------------------------------------------------
  # Categories
  # ---------------------------------------------------------------------------

  @spec list_categories(String.t()) :: [Category.t()]
  def list_categories(type \\ "offer") do
    Cache.fetch_categories(type, fn ->
      Repo.all(from c in Category, where: c.type == ^type, order_by: c.name)
    end)
  end

  def get_category!(id), do: Repo.get!(Category, id)

  def create_category(attrs) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end
end
