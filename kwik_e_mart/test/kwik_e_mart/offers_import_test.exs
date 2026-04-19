defmodule KwikEMart.OffersImportTest do
  use KwikEMart.DataCase

  alias KwikEMart.Offers

  setup do
    {:ok, cat} = Offers.create_category(%{name: "Getränke", slug: "getraenke", type: "offer"})
    %{category: cat}
  end

  describe "import_weekly_offers/1" do
    test "importiert Angebote aus einer CSV-Datei", %{category: _cat} do
      path = write_temp_csv("""
      title,description,price,original_price,discount_percent,category_slug,featured,image_url
      Duff Beer 6er-Pack,Homer's Lieblingsgetränk,3.99,5.49,27,getraenke,true,/images/duff-beer.svg
      Buzz Cola 1.5l,Kalt und spritzig,0.99,1.49,34,getraenke,false,/images/buzz-cola.svg
      """)

      assert {:ok, 2} = Offers.import_weekly_offers(path)
      offers = Offers.list_offers()
      assert length(offers) == 2
      assert Enum.any?(offers, &(&1.title == "Duff Beer 6er-Pack"))
    end

    test "setzt valid_from auf heute und valid_to auf heute + 6" do
      path = write_temp_csv("""
      title,description,price,original_price,discount_percent,category_slug,featured,image_url
      Squishee,Tropical,0.79,1.29,39,getraenke,false,/images/squishee.svg
      """)

      assert {:ok, 1} = Offers.import_weekly_offers(path)
      [offer] = Offers.list_offers()
      today = Date.utc_today()
      assert offer.valid_from == today
      assert offer.valid_to == Date.add(today, 6)
    end

    test "überspringt Angebote mit fehlendem Pflichtfeld" do
      path = write_temp_csv("""
      title,description,price,original_price,discount_percent,category_slug,featured,image_url
      ,Kein Titel,1.99,2.99,10,getraenke,false,/images/x.svg
      Duff Beer,OK,3.99,5.49,27,getraenke,true,/images/duff-beer.svg
      """)

      assert {:ok, 1} = Offers.import_weekly_offers(path)
    end

    test "verarbeitet unbekannte Kategorie-Slugs (nil category_id)" do
      path = write_temp_csv("""
      title,description,price,original_price,discount_percent,category_slug,featured,image_url
      Krusty-Burger,Springfield-Klassiker,2.49,3.29,24,unknown-slug,false,/images/x.svg
      """)

      assert {:ok, 1} = Offers.import_weekly_offers(path)
      [offer] = Offers.list_offers()
      assert is_nil(offer.category_id)
    end

    test "gibt {:error, _} bei nicht vorhandener Datei zurück" do
      assert {:error, _reason} = Offers.import_weekly_offers("/tmp/does_not_exist_kwik.csv")
    end

    test "gibt {:ok, 0} bei leerer CSV zurück" do
      path = write_temp_csv("title,description,price,original_price,discount_percent,category_slug,featured,image_url\n")
      assert {:ok, 0} = Offers.import_weekly_offers(path)
    end
  end

  defp write_temp_csv(content) do
    path = System.tmp_dir!() |> Path.join("kwik_test_#{System.unique_integer()}.csv")
    File.write!(path, String.trim_leading(content))
    on_exit(fn -> File.rm(path) end)
    path
  end
end
