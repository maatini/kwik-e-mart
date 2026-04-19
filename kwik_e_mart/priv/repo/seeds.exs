alias KwikEMart.Repo
alias KwikEMart.Markets.Market
alias KwikEMart.Offers.{Offer, Category}
alias KwikEMart.Recipes.Recipe

# --- Kategorien ---
offer_categories =
  [
    %{name: "Obst & Gemüse", slug: "obst-gemuese", type: "offer", icon: "🥦"},
    %{name: "Fleisch & Fisch", slug: "fleisch-fisch", type: "offer", icon: "🥩"},
    %{name: "Milch & Käse", slug: "milch-kaese", type: "offer", icon: "🧀"},
    %{name: "Brot & Backwaren", slug: "brot-backwaren", type: "offer", icon: "🍞"},
    %{name: "Getränke", slug: "getraenke", type: "offer", icon: "🍺"}
  ]
  |> Enum.map(fn attrs ->
    %Category{} |> Category.changeset(attrs) |> Repo.insert!(on_conflict: :nothing, conflict_target: [:slug, :type])
  end)

recipe_categories =
  [
    %{name: "Frühling", slug: "fruehling", type: "recipe", icon: "🌸"},
    %{name: "Spargel", slug: "spargel", type: "recipe", icon: "🌿"},
    %{name: "Salat", slug: "salat", type: "recipe", icon: "🥗"},
    %{name: "Dessert", slug: "dessert", type: "recipe", icon: "🍮"}
  ]
  |> Enum.map(fn attrs ->
    %Category{} |> Category.changeset(attrs) |> Repo.insert!(on_conflict: :nothing, conflict_target: [:slug, :type])
  end)

[cat_obst, cat_fleisch, cat_milch, cat_brot, cat_getraenke] = offer_categories
[cat_fruehling, cat_spargel, cat_salat, cat_dessert] = recipe_categories

# --- Märkte ---
markets =
  [
    %{name: "EDEKA Müller", city: "München", zip: "80331", street: "Marienplatz 1", latitude: 48.1374, longitude: 11.5755, region: "Bayern"},
    %{name: "EDEKA Schneider", city: "Berlin", zip: "10115", street: "Unter den Linden 20", latitude: 52.5163, longitude: 13.3777, region: "Berlin"},
    %{name: "EDEKA Weber", city: "Hamburg", zip: "20095", street: "Mönckebergstraße 7", latitude: 53.5503, longitude: 10.0006, region: "Hamburg"},
    %{name: "EDEKA Fischer", city: "Stuttgart", zip: "70173", street: "Königstraße 5", latitude: 48.7775, longitude: 9.1800, region: "Baden-Württemberg"},
    %{name: "EDEKA Schmidt", city: "Frankfurt", zip: "60313", street: "Zeil 112", latitude: 50.1136, longitude: 8.6825, region: "Hessen"}
  ]
  |> Enum.map(fn attrs ->
    %Market{} |> Market.changeset(attrs) |> Repo.insert!()
  end)

[market_muenchen, market_berlin, market_hamburg, market_stuttgart, market_frankfurt] = markets

# --- Angebote (gültig April 2026 – Frühlings-Saison) ---
offers_data = [
  %{title: "Deutscher Spargel weiß", description: "Frischer Spargel aus der Region, 500g", price: "2.49", original_price: "3.99", discount_percent: 38, image_url: "/images/spargel.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_muenchen.id, category_id: cat_obst.id},
  %{title: "Erdbeeren 500g", description: "Süße Frühlings-Erdbeeren", price: "1.99", original_price: "2.99", discount_percent: 33, image_url: "/images/erdbeeren.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_muenchen.id, category_id: cat_obst.id},
  %{title: "Bio Babyspinat 150g", description: "Zarter Babyspinat, bio-zertifiziert", price: "1.49", original_price: "1.99", discount_percent: 25, image_url: "/images/spinat.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_muenchen.id, category_id: cat_obst.id},
  %{title: "Hähnchenbrust 600g", description: "Frische Hähnchenbrust, aus Bayern", price: "3.99", original_price: "5.49", discount_percent: 27, image_url: "/images/haehnchen.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_muenchen.id, category_id: cat_fleisch.id},
  %{title: "Lachs-Filet 400g", description: "Atlantischer Lachs, küchenfertig", price: "4.99", original_price: "7.49", discount_percent: 33, image_url: "/images/lachs.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_berlin.id, category_id: cat_fleisch.id},
  %{title: "Grüner Spargel 500g", description: "Knackiger grüner Spargel", price: "2.29", original_price: "3.49", discount_percent: 34, image_url: "/images/gruen-spargel.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_berlin.id, category_id: cat_obst.id},
  %{title: "Mozzarella di Bufala 125g", description: "Original Büffelmozzarella", price: "1.79", original_price: "2.49", discount_percent: 28, image_url: "/images/mozzarella.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_berlin.id, category_id: cat_milch.id},
  %{title: "Vollkornbrot 750g", description: "Rustikales Vollkornbrot, frisch gebacken", price: "1.99", original_price: "2.79", discount_percent: 29, image_url: "/images/vollkornbrot.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_berlin.id, category_id: cat_brot.id},
  %{title: "Radieschen Bund", description: "Knackige Radieschen, regional", price: "0.79", original_price: "1.19", discount_percent: 34, image_url: "/images/radieschen.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_hamburg.id, category_id: cat_obst.id},
  %{title: "Rhabarber 500g", description: "Frischer Rhabarber für Kuchen & Kompott", price: "1.29", original_price: "1.79", discount_percent: 28, image_url: "/images/rhabarber.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_hamburg.id, category_id: cat_obst.id},
  %{title: "Frische Pasta 500g", description: "Tagliatelle frisch, mit Ei", price: "1.99", original_price: "2.79", discount_percent: 29, image_url: "/images/pasta.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_hamburg.id, category_id: cat_brot.id},
  %{title: "Holsten Pils 6x0,5l", description: "Das Hamburger Original", price: "3.99", original_price: "5.49", discount_percent: 27, image_url: "/images/bier.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_hamburg.id, category_id: cat_getraenke.id},
  %{title: "Maultaschen 400g", description: "Schwäbische Maultaschen, hausgemacht", price: "2.49", original_price: "3.29", discount_percent: 24, image_url: "/images/maultaschen.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_stuttgart.id, category_id: cat_fleisch.id},
  %{title: "Frühlingszwiebeln 2 Bund", description: "Zarte Frühlingszwiebeln", price: "0.99", original_price: "1.49", discount_percent: 34, image_url: "/images/fruehlingszwiebeln.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_stuttgart.id, category_id: cat_obst.id},
  %{title: "Berchtesgadener Joghurt 500g", description: "Bio-Vollmilchjoghurt natur", price: "1.49", original_price: "1.99", discount_percent: 25, image_url: "/images/joghurt.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_stuttgart.id, category_id: cat_milch.id},
  %{title: "Grüne Soße Kräuter-Mix", description: "7 Frankfurter Kräuter, frisch gemischt", price: "1.79", original_price: "2.49", discount_percent: 28, image_url: "/images/gruene-sosse.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_frankfurt.id, category_id: cat_obst.id},
  %{title: "Apfelwein 1l", description: "Hessischer Apfelwein trocken", price: "1.49", original_price: "1.99", discount_percent: 25, image_url: "/images/apfelwein.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_frankfurt.id, category_id: cat_getraenke.id},
  %{title: "Handkäse 200g", description: "Hessischer Handkäse mit Musik", price: "1.29", original_price: "1.79", discount_percent: 28, image_url: "/images/handkaese.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_frankfurt.id, category_id: cat_milch.id},
  %{title: "Frankfurter Würstchen 6 Stück", description: "Original Frankfurter, geräuchert", price: "2.99", original_price: "3.99", discount_percent: 25, image_url: "/images/wuerstchen.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_frankfurt.id, category_id: cat_fleisch.id},
  %{title: "Butter 250g", description: "Deutsche Markenbutter mild gesäuert", price: "1.69", original_price: "2.19", discount_percent: 23, image_url: "/images/butter.jpg", valid_from: ~D[2026-04-14], valid_to: ~D[2026-04-26], market_id: market_frankfurt.id, category_id: cat_milch.id}
]

Enum.each(offers_data, fn attrs ->
  %Offer{} |> Offer.changeset(attrs) |> Repo.insert!()
end)

# --- Rezepte (Frühling/Spargel-Saison 2026) ---
recipes_data = [
  %{
    title: "Spargel mit Sauce Hollandaise",
    description: "Klassischer weißer Spargel mit hausgemachter Sauce Hollandaise und Kartoffeln",
    ingredients: ["1 kg weißer Spargel", "200g Butter", "4 Eigelb", "1 EL Zitronensaft", "Salz, Pfeffer", "500g neue Kartoffeln"],
    instructions: "Spargel schälen und 12 Min. kochen. Butter klären. Eigelb aufschlagen, Butter einarbeiten. Mit Kartoffeln anrichten.",
    prep_time: 35, image_url: "/images/rezept-spargel-hollandaise.jpg",
    tags: ["spargel", "klassisch", "frühling", "festlich"], seasonal: true, category_id: cat_spargel.id
  },
  %{
    title: "Grüner Spargel mit Parmesan",
    description: "Knackiger grüner Spargel aus dem Ofen mit Parmesan und Zitrone",
    ingredients: ["500g grüner Spargel", "50g Parmesan gerieben", "2 EL Olivenöl", "1 Bio-Zitrone", "Meersalz, Pfeffer"],
    instructions: "Ofen auf 200°C. Spargel in Öl wenden, 15 Min. rösten. Mit Parmesan und Zitronenschale servieren.",
    prep_time: 20, image_url: "/images/rezept-gruen-spargel.jpg",
    tags: ["spargel", "vegetarisch", "schnell", "frühling"], seasonal: true, category_id: cat_spargel.id
  },
  %{
    title: "Erdbeer-Rhabarber-Tarte",
    description: "Fruchtige Frühlingstarte mit frischen Erdbeeren und Rhabarber",
    ingredients: ["300g Mehl", "150g Butter", "100g Zucker", "300g Erdbeeren", "300g Rhabarber", "2 Eier"],
    instructions: "Mürbteig herstellen. Rhabarber zuckern. Boden blind backen. Füllung einarbeiten, 30 Min. bei 180°C.",
    prep_time: 60, image_url: "/images/rezept-erdbeer-tarte.jpg",
    tags: ["backen", "erdbeeren", "rhabarber", "frühling"], seasonal: true, category_id: cat_dessert.id
  },
  %{
    title: "Frankfurter Grüne Soße",
    description: "Traditionelle Frankfurter Spezialität mit hartgekochten Eiern",
    ingredients: ["1 Bund Grüne Soße Kräuter", "200g Schmand", "200g Joghurt", "4 Eier", "1 EL Senf"],
    instructions: "Kräuter hacken, mit Schmand und Joghurt verrühren. Würzen. Mit Eiern und Kartoffeln servieren.",
    prep_time: 25, image_url: "/images/rezept-gruene-sosse.jpg",
    tags: ["hessen", "regional", "vegetarisch"], seasonal: false, category_id: cat_fruehling.id
  },
  %{
    title: "Frühlings-Blattsalat mit Radieschen",
    description: "Leichter Salat mit Babyspinat, Radieschen und Honig-Senf-Dressing",
    ingredients: ["150g Babyspinat", "1 Bund Radieschen", "100g Frühlingszwiebeln", "50g Walnüsse", "Olivenöl", "Weißweinessig", "Honig"],
    instructions: "Spinat waschen. Radieschen in Scheiben. Dressing anrühren. Alles vermischen. Walnüsse rösten.",
    prep_time: 15, image_url: "/images/rezept-fruehlingsalat.jpg",
    tags: ["salat", "vegetarisch", "schnell", "frühling"], seasonal: true, category_id: cat_salat.id
  },
  %{
    title: "Spargel-Risotto mit Zitrone",
    description: "Cremiges Risotto mit weißem Spargel und frischer Zitrone",
    ingredients: ["500g weißer Spargel", "250g Risottoreis", "100ml Weißwein", "1l Gemüsebrühe", "50g Parmesan", "30g Butter"],
    instructions: "Spargel schälen. Zwiebel anschwitzen. Reis mit Wein ablöschen. Brühe angießen. Spargel zugeben. Mit Butter vollenden.",
    prep_time: 40, image_url: "/images/rezept-spargel-risotto.jpg",
    tags: ["spargel", "vegetarisch", "risotto"], seasonal: true, category_id: cat_spargel.id
  },
  %{
    title: "Hähnchen-Pfanne mit Frühlingszwiebeln",
    description: "Saftige Hähnchenbrust mit Frühlingszwiebeln und frischen Kräutern",
    ingredients: ["600g Hähnchenbrust", "2 Bund Frühlingszwiebeln", "3 Knoblauchzehen", "200ml Brühe", "Frische Kräuter"],
    instructions: "Hähnchen anbraten. Knoblauch und Zwiebeln zugeben. Mit Brühe ablöschen. 10 Min. köcheln. Kräuter unterheben.",
    prep_time: 25, image_url: "/images/rezept-haehnchen-pfanne.jpg",
    tags: ["haehnchen", "schnell", "frühling"], seasonal: false, category_id: cat_fruehling.id
  },
  %{
    title: "Rhabarber-Kompott mit Vanille",
    description: "Einfaches Kompott, perfekt zu Vanilleeis oder Quark",
    ingredients: ["500g Rhabarber", "100g Zucker", "1 Vanilleschote", "50ml Wasser"],
    instructions: "Rhabarber schälen, mit Zucker aufkochen. 10 Min. köcheln. Abkühlen lassen.",
    prep_time: 20, image_url: "/images/rezept-rhabarber-kompott.jpg",
    tags: ["rhabarber", "dessert", "frühling", "einfach"], seasonal: true, category_id: cat_dessert.id
  },
  %{
    title: "Pasta mit grünem Spargel und Garnelen",
    description: "Frische Tagliatelle mit grünem Spargel und Zitronenbutter",
    ingredients: ["500g frische Tagliatelle", "400g grüner Spargel", "300g Garnelen", "50g Butter", "1 Zitrone", "Weißwein"],
    instructions: "Pasta kochen. Spargel anbraten. Garnelen zugeben. Mit Weißwein ablöschen. Butter einrühren. Mit Pasta mischen.",
    prep_time: 30, image_url: "/images/rezept-pasta-spargel.jpg",
    tags: ["spargel", "pasta", "meeresfrüchte"], seasonal: true, category_id: cat_spargel.id
  },
  %{
    title: "Schwäbische Maultaschen-Pfanne",
    description: "Gebratene Maultaschen mit karamellisierten Zwiebeln",
    ingredients: ["400g Maultaschen", "2 Zwiebeln", "3 Eier", "100ml Brühe", "Schnittlauch"],
    instructions: "Zwiebeln karamellisieren. Maultaschen in Scheiben anbraten. Eier drüber. Mit Brühe ablöschen.",
    prep_time: 20, image_url: "/images/rezept-maultaschen.jpg",
    tags: ["schwaben", "regional", "traditionell"], seasonal: false, category_id: cat_fruehling.id
  }
]

Enum.each(recipes_data, fn attrs ->
  %Recipe{} |> Recipe.changeset(attrs) |> Repo.insert!()
end)

IO.puts("✅ Seeds erfolgreich: 5 Märkte, #{length(offers_data)} Angebote, #{length(recipes_data)} Rezepte")
