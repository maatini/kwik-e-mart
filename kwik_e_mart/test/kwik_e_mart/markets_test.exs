defmodule KwikEMart.MarketsTest do
  use KwikEMart.DataCase

  alias KwikEMart.Markets
  alias KwikEMart.Markets.Market

  @valid_attrs %{
    name: "EDEKA Testmarkt",
    city: "Hamburg",
    zip: "20095",
    street: "Teststraße 1",
    latitude: 53.5503,
    longitude: 10.0006,
    region: "Hamburg"
  }

  describe "list_markets/0" do
    test "gibt alle Märkte zurück" do
      {:ok, market} = Markets.create_market(@valid_attrs)
      markets = Markets.list_markets()
      ids = Enum.map(markets, & &1.id)
      assert market.id in ids
    end
  end

  describe "get_market!/1" do
    test "gibt Markt bei gültiger ID zurück" do
      {:ok, market} = Markets.create_market(@valid_attrs)
      assert Markets.get_market!(market.id).id == market.id
    end

    test "wirft Fehler bei ungültiger ID" do
      assert_raise Ecto.NoResultsError, fn -> Markets.get_market!(0) end
    end
  end

  describe "create_market/1" do
    test "erstellt Markt mit gültigen Attributen" do
      assert {:ok, %Market{} = market} = Markets.create_market(@valid_attrs)
      assert market.name == "EDEKA Testmarkt"
      assert market.city == "Hamburg"
      assert market.zip == "20095"
    end

    test "gibt Fehler bei fehlenden Pflichtfeldern zurück" do
      assert {:error, changeset} = Markets.create_market(%{})
      assert %{name: ["can't be blank"], city: ["can't be blank"]} = errors_on(changeset)
    end

    test "gibt Fehler bei ungültiger PLZ zurück" do
      attrs = Map.put(@valid_attrs, :zip, "1")
      assert {:error, changeset} = Markets.create_market(attrs)
      assert %{zip: [_]} = errors_on(changeset)
    end
  end

  describe "search_markets/1" do
    test "findet Märkte nach Stadt" do
      {:ok, _} = Markets.create_market(@valid_attrs)
      results = Markets.search_markets("Hamburg")
      assert length(results) >= 1
      assert Enum.all?(results, fn m -> String.contains?(m.city, "Hamburg") end)
    end

    test "gibt leere Liste bei Suche mit < 2 Zeichen zurück" do
      assert [] = Markets.search_markets("H")
      assert [] = Markets.search_markets("")
    end
  end

  describe "update_market/2" do
    test "aktualisiert Markt mit gültigen Attributen" do
      {:ok, market} = Markets.create_market(@valid_attrs)
      assert {:ok, updated} = Markets.update_market(market, %{name: "EDEKA Neumarkt"})
      assert updated.name == "EDEKA Neumarkt"
    end
  end

  describe "delete_market/1" do
    test "löscht Markt" do
      {:ok, market} = Markets.create_market(@valid_attrs)
      assert {:ok, _} = Markets.delete_market(market)
      assert_raise Ecto.NoResultsError, fn -> Markets.get_market!(market.id) end
    end
  end
end
