defmodule KwikEMart.OffersTest do
  use KwikEMart.DataCase

  alias KwikEMart.{Offers, Markets}
  alias KwikEMart.Offers.{Offer, Category}

  setup do
    {:ok, market} =
      Markets.create_market(%{
        name: "EDEKA Test",
        city: "Berlin",
        zip: "10115",
        street: "Teststr. 1"
      })

    {:ok, category} =
      Offers.create_category(%{name: "Obst & Gemüse", slug: "obst", type: "offer"})

    today = Date.utc_today()

    %{market: market, category: category, today: today}
  end

  defp offer_attrs(market_id, opts \\ []) do
    today = Date.utc_today()

    %{
      title: "Testangebot",
      price: "1.99",
      valid_from: Keyword.get(opts, :valid_from, today),
      valid_to: Keyword.get(opts, :valid_to, Date.add(today, 7)),
      market_id: market_id,
      discount_percent: Keyword.get(opts, :discount_percent, 20)
    }
  end

  describe "list_offers/1" do
    test "gibt nur aktuell gültige Angebote zurück", %{market: market, today: today} do
      {:ok, _current} = Offers.create_offer(offer_attrs(market.id))

      {:ok, _expired} =
        Offers.create_offer(
          offer_attrs(market.id,
            valid_from: Date.add(today, -14),
            valid_to: Date.add(today, -1)
          )
        )

      offers = Offers.list_offers()
      assert Enum.all?(offers, fn o -> Date.compare(o.valid_to, today) != :lt end)
    end

    test "filtert nach Markt", %{market: market} do
      {:ok, _offer} = Offers.create_offer(offer_attrs(market.id))
      offers = Offers.list_offers(market_id: market.id)
      assert Enum.all?(offers, fn o -> o.market_id == market.id end)
    end

    test "filtert nach Kategorie", %{market: market, category: category} do
      {:ok, _offer} =
        Offers.create_offer(Map.put(offer_attrs(market.id), :category_id, category.id))

      offers = Offers.list_offers(category_id: category.id)
      assert Enum.all?(offers, fn o -> o.category_id == category.id end)
    end
  end

  describe "create_offer/1" do
    test "erstellt Angebot mit gültigen Attributen", %{market: market} do
      assert {:ok, %Offer{} = offer} = Offers.create_offer(offer_attrs(market.id))
      assert offer.title == "Testangebot"
      assert Decimal.equal?(offer.price, Decimal.new("1.99"))
    end

    test "gibt Fehler bei negativem Preis zurück", %{market: market} do
      attrs = Map.put(offer_attrs(market.id), :price, "-1.00")
      assert {:error, changeset} = Offers.create_offer(attrs)
      assert %{price: [_]} = errors_on(changeset)
    end

    test "gibt Fehler wenn valid_to vor valid_from liegt", %{market: market, today: today} do
      attrs =
        offer_attrs(market.id,
          valid_from: today,
          valid_to: Date.add(today, -1)
        )

      assert {:error, changeset} = Offers.create_offer(attrs)
      assert %{valid_to: [_]} = errors_on(changeset)
    end

    test "gibt Fehler bei fehlendem Markt" do
      attrs = offer_attrs(0)
      assert {:error, _changeset} = Offers.create_offer(attrs)
    end
  end

  describe "list_categories/1" do
    test "gibt Kategorien nach Typ zurück", %{category: _} do
      categories = Offers.list_categories("offer")
      assert Enum.all?(categories, fn c -> c.type == "offer" end)
    end
  end

  describe "create_category/1" do
    test "erstellt Kategorie mit eindeutigem Slug" do
      assert {:ok, %Category{}} =
               Offers.create_category(%{name: "Fleisch", slug: "fleisch-unique", type: "offer"})
    end

    test "gibt Fehler bei ungültigem Typ zurück" do
      assert {:error, changeset} =
               Offers.create_category(%{name: "X", slug: "x", type: "invalid"})

      assert %{type: [_]} = errors_on(changeset)
    end
  end
end
