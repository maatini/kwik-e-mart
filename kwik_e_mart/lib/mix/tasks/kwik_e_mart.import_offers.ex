defmodule Mix.Tasks.KwikEMart.ImportOffers do
  use Mix.Task

  @shortdoc "Importiert Wochenangebote aus einer CSV-Datei"

  @moduledoc """
  Importiert Wochenangebote aus einer CSV-Datei in die Datenbank.

  ## Verwendung

      mix kwik_e_mart.import_offers
      mix kwik_e_mart.import_offers /pfad/zur/datei.csv

  Ohne Pfad wird `priv/import/current_week.csv` verwendet.

  CSV-Format (mit Header-Zeile):
    title,description,price,original_price,discount_percent,category_slug,featured,image_url
  """

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    path =
      case args do
        [p | _] -> p
        [] -> Application.app_dir(:kwik_e_mart, "priv/import/current_week.csv")
      end

    Mix.shell().info("🥤 Kwik-E-Mart Angebots-Import startet…")
    Mix.shell().info("   Datei: #{path}")

    case KwikEMart.Offers.import_weekly_offers(path) do
      {:ok, count} ->
        Mix.shell().info("✅ #{count} Angebote erfolgreich importiert. Thank you, come again!")

      {:error, reason} ->
        Mix.shell().error("❌ Import fehlgeschlagen: #{inspect(reason)}")
        exit({:shutdown, 1})
    end
  end
end
