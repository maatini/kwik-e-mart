alias KwikEMart.Repo
alias KwikEMart.Markets.Market
alias KwikEMart.Offers.{Offer, Category}
alias KwikEMart.Recipes.Recipe

# ---------------------------------------------------------------------------
# Kategorien
# ---------------------------------------------------------------------------

offer_categories =
  [
    %{name: "Getränke", slug: "getraenke", type: "offer", icon: "🥤"},
    %{name: "Snacks & Imbiss", slug: "snacks", type: "offer", icon: "🌭"},
    %{name: "Frühstück", slug: "fruehstueck", type: "offer", icon: "🥣"},
    %{name: "Eigenmarken", slug: "eigenmarken", type: "offer", icon: "⭐"},
    %{name: "Lotterie & Mehr", slug: "lotterie", type: "offer", icon: "🎰"}
  ]
  |> Enum.map(fn attrs ->
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert!(on_conflict: :nothing, conflict_target: [:slug, :type])
  end)

recipe_categories =
  [
    %{name: "Apu's Küche", slug: "apus-kueche", type: "recipe", icon: "🍛"},
    %{name: "Homer's Favourites", slug: "homers-favs", type: "recipe", icon: "🍩"},
    %{name: "Schnell & Einfach", slug: "schnell", type: "recipe", icon: "⚡"},
    %{name: "Vegetarisch", slug: "vegetarisch", type: "recipe", icon: "🌿"}
  ]
  |> Enum.map(fn attrs ->
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert!(on_conflict: :nothing, conflict_target: [:slug, :type])
  end)

[cat_getraenke, cat_snacks, cat_fruehstueck, cat_eigen, cat_lotterie] = offer_categories
[cat_apu, cat_homer, cat_schnell, cat_veg] = recipe_categories

# ---------------------------------------------------------------------------
# Märkte
# ---------------------------------------------------------------------------

markets =
  [
    %{
      name: "Kwik-E-Mart Springfield Downtown",
      city: "Springfield",
      zip: "58008",
      street: "742 Evergreen Terrace",
      latitude: 39.7684,
      longitude: -86.1581,
      region: "Springfield County"
    },
    %{
      name: "Kwik-E-Mart Shelbyville",
      city: "Shelbyville",
      zip: "58030",
      street: "1 Shelbyville Plaza",
      latitude: 39.7550,
      longitude: -86.1400,
      region: "Springfield County"
    },
    %{
      name: "Kwik-E-Mart Springfield Heights",
      city: "Springfield",
      zip: "58012",
      street: "321 Springfield Heights Blvd",
      latitude: 39.7800,
      longitude: -86.1700,
      region: "Springfield County"
    },
    %{
      name: "Kwik-E-Mart Capital City",
      city: "Capital City",
      zip: "60001",
      street: "99 Capital Mall Drive",
      latitude: 40.1200,
      longitude: -86.5000,
      region: "Capital District"
    },
    %{
      name: "Kwik-E-Mart Ogdenville",
      city: "Ogdenville",
      zip: "58099",
      street: "5 Ogdenville Main St",
      latitude: 39.9000,
      longitude: -86.3000,
      region: "North Tastings"
    }
  ]
  |> Enum.map(fn attrs ->
    %Market{} |> Market.changeset(attrs) |> Repo.insert!()
  end)

[mkt_downtown, mkt_shelby, mkt_heights, mkt_capital, mkt_ogden] = markets

# ---------------------------------------------------------------------------
# Angebote (gültig April–Mai 2026)
# ---------------------------------------------------------------------------

valid_from = ~D[2026-04-19]
valid_to = ~D[2026-05-03]

offers_data = [
  # Getränke
  %{
    title: "Squishee Tropical 0,5l",
    description:
      "Der Original Springfield Slush in fruchtig-tropischer Geschmacksrichtung. Jetzt im Sommerangebot!",
    price: "0.99",
    original_price: "1.49",
    discount_percent: 34,
    image_url: "/images/squishee-tropical.svg",
    valid_from: valid_from,
    valid_to: valid_to,
    market_id: mkt_downtown.id,
    category_id: cat_getraenke.id
  },
  %{
    title: "Duff Beer 6-Pack 0,33l",
    description:
      "Homers Lieblingsgetränk im praktischen Sixpack. Kalt gestellt und fertig für den Feierabend.",
    price: "4.99",
    original_price: "6.99",
    discount_percent: 29,
    image_url: "/images/duff-beer.svg",
    valid_from: valid_from,
    valid_to: valid_to,
    market_id: mkt_downtown.id,
    category_id: cat_getraenke.id
  },
  %{
    title: "Buzz Cola 1,5l",
    description: "Springfield's koffeinreichste Cola. Der Favorit von Bart und seinen Freunden.",
    price: "0.89",
    original_price: "1.29",
    discount_percent: 31,
    image_url: "/images/buzz-cola.svg",
    valid_from: valid_from,
    valid_to: valid_to,
    market_id: mkt_shelby.id,
    category_id: cat_getraenke.id
  },
  %{
    title: "Squishee Berry Blast 0,5l",
    description:
      "Waldbeeren-Squishee in der limitierten Sommerediton. Nur solange der Vorrat reicht!",
    price: "0.99",
    original_price: "1.49",
    discount_percent: 34,
    image_url: "/images/squishee-berry.svg",
    valid_from: valid_from,
    valid_to: valid_to,
    market_id: mkt_heights.id,
    category_id: cat_getraenke.id
  },

  # Snacks & Imbiss
  %{
    title: "Kwik-E-Mart Hot Dog",
    description:
      "Klassischer Springfield Hot Dog – seit 3 Tagen auf der Rolle, garantiert warm. Mit Senf nach Wahl.",
    price: "1.79",
    original_price: "2.49",
    discount_percent: 28,
    image_url: "/images/hot-dog.svg",
    valid_from: valid_from,
    valid_to: valid_to,
    market_id: mkt_downtown.id,
    category_id: cat_snacks.id
  },
  %{
    title: "Ribwich Burger (limitiert)",
    description:
      "Der legendäre Ribwich ist zurück! Nur für kurze Zeit – hol ihn dir, bevor Homer alles aufisst.",
    price: "3.49",
    original_price: "4.99",
    discount_percent: 30,
    image_url: "/images/ribwich.svg",
    valid_from: valid_from,
    valid_to: valid_to,
    market_id: mkt_downtown.id,
    category_id: cat_snacks.id
  },
  %{
    title: "Chief Wiggum's Hot Sauce 150ml",
    description:
      "Schärfer als das Springfield PD! Handgemachte Hot Sauce mit echten Springfield-Jalapeños.",
    price: "2.29",
    original_price: "3.19",
    discount_percent: 28,
    image_url: "/images/hot-sauce.svg",
    valid_from: valid_from,
    valid_to: valid_to,
    market_id: mkt_shelby.id,
    category_id: cat_snacks.id
  },
  %{
    title: "Springfield Donuts 6 Stück",
    description:
      "Pink glasierte Donuts mit Streuseln – Homers ewige Schwäche. Frisch aus dem Kwik-E-Mart-Ofen.",
    price: "1.99",
    original_price: "2.99",
    discount_percent: 33,
    image_url: "/images/donuts.svg",
    valid_from: valid_from,
    valid_to: valid_to,
    market_id: mkt_heights.id,
    category_id: cat_snacks.id
  },

  # Frühstück
  %{
    title: "Krusty-O's Cerealien 500g",
    description:
      "Das Frühstücks-Cerealien von Krusty dem Clown! Mit O-Vitamin angereichert (Warnhinweis auf der Rückseite lesen).",
    price: "2.49",
    original_price: "3.99",
    discount_percent: 38,
    image_url: "/images/krusty-os.svg",
    valid_from: valid_from,
    valid_to: valid_to,
    market_id: mkt_downtown.id,
    category_id: cat_fruehstueck.id
  },
  %{
    title: "Apu's Chai Masala Tee 20 Beutel",
    description:
      "Apus persönliches Familienrezept aus Indien. Würzig, aromatisch, der perfekte Morgenstart.",
    price: "1.99",
    original_price: "2.79",
    discount_percent: 29,
    image_url: "/images/chai-masala.svg",
    valid_from: valid_from,
    valid_to: valid_to,
    market_id: mkt_capital.id,
    category_id: cat_fruehstueck.id
  },

  # Eigenmarken
  %{
    title: "Apu's Curry-Paste 200g",
    description:
      "Apus geheimes Familienrezept – milde bis feurige Currypaste aus echter Springfield-Produktion.",
    price: "1.79",
    original_price: "2.49",
    discount_percent: 28,
    image_url: "/images/curry-paste.svg",
    valid_from: valid_from,
    valid_to: valid_to,
    market_id: mkt_downtown.id,
    category_id: cat_eigen.id
  },
  %{
    title: "Kwik-E-Mart Energie-Riegel 3er-Pack",
    description:
      "Für den langen Schichtdienst: Apus bewährter Energie-Riegel. Hält 24 Stunden frisch – genau wie wir.",
    price: "1.49",
    original_price: "1.99",
    discount_percent: 25,
    image_url: "/images/energie-riegel.svg",
    valid_from: valid_from,
    valid_to: valid_to,
    market_id: mkt_shelby.id,
    category_id: cat_eigen.id
  },

  # Lotterie & Mehr
  %{
    title: "Springfield Lottoschein",
    description:
      "Diese Woche Jackpot: 42 Millionen Dollar! Holen Sie sich Ihren Schein – Apu verkauft nur Gewinnlos.",
    price: "1.00",
    original_price: "1.00",
    discount_percent: 0,
    image_url: "/images/lotto.svg",
    valid_from: valid_from,
    valid_to: valid_to,
    market_id: mkt_downtown.id,
    category_id: cat_lotterie.id
  },
  %{
    title: "Scratchy's Rubbel-Los",
    description:
      "Neu! Das Scratchy-Rubbellos mit Gewinnchancen von 1:1.000.000. Itchy nicht inbegriffen.",
    price: "2.00",
    original_price: "2.00",
    discount_percent: 0,
    image_url: "/images/rubbellos.svg",
    valid_from: valid_from,
    valid_to: valid_to,
    market_id: mkt_ogden.id,
    category_id: cat_lotterie.id
  }
]

Enum.each(offers_data, fn attrs ->
  %Offer{} |> Offer.changeset(attrs) |> Repo.insert!()
end)

# ---------------------------------------------------------------------------
# Rezepte (Apu-Edition)
# ---------------------------------------------------------------------------

recipes_data = [
  %{
    title: "Apu's Chicken Tikka Masala",
    description:
      "Apus Familienrezept aus Rahgul – cremige Tomaten-Masala-Sauce mit zarter Hähnchenbrust. So kocht man in Springfield Indien.",
    ingredients: [
      "600g Hähnchenbrust",
      "400ml Kokosmilch",
      "400g gehackte Tomaten",
      "2 EL Apus Curry-Paste",
      "1 Zwiebel",
      "3 Knoblauchzehen",
      "1 Stück Ingwer (3cm)",
      "Garam Masala",
      "Koriander",
      "Basmatireis"
    ],
    instructions:
      "Hähnchen würfeln und anbraten. Zwiebel, Knoblauch und Ingwer anschwitzen. Curry-Paste einrühren, 2 Min. rösten. Tomaten und Kokosmilch zugeben, 20 Min. köcheln. Mit Garam Masala abschmecken. Mit Reis und frischem Koriander servieren.",
    prep_time: 45,
    difficulty: "mittel",
    servings: 4,
    image_url: "/images/rezept-tikka-masala.svg",
    tags: ["indisch", "hähnchen", "apu", "hauptgericht"],
    seasonal: false,
    category_id: cat_apu.id
  },
  %{
    title: "Homer's Donut Bread Pudding",
    description:
      "Homer's geniale Erfindung: Was tut man mit übrigen Donuts? Man macht ein Bread Pudding daraus! D'oh – so einfach und so gut.",
    ingredients: [
      "6 Springfield-Donuts (vom Vortag)",
      "3 Eier",
      "300ml Milch",
      "100ml Sahne",
      "50g Zucker",
      "1 TL Vanilleextrakt",
      "Prise Zimt",
      "rosa Zuckerglasur zum Garnieren"
    ],
    instructions:
      "Donuts in Stücke reißen. Eier, Milch, Sahne, Zucker und Vanille verquirlen. Donuts einweichen, 30 Min. ziehen lassen. In gefetteter Form bei 175°C, 35 Min. backen. Warm mit Glasur servieren.",
    prep_time: 60,
    difficulty: "leicht",
    servings: 6,
    image_url: "/images/rezept-donut-pudding.svg",
    tags: ["dessert", "backen", "homer", "süß"],
    seasonal: false,
    category_id: cat_homer.id
  },
  %{
    title: "Squishee Smoothie Bowl",
    description:
      "Bart's Geheimtipp: Squishee nicht trinken – als Smoothie Bowl servieren! Schnell, bunt, perfekt für einen Springfield-Morgen.",
    ingredients: [
      "1 Squishee Tropical (eingefroren)",
      "1 Banane",
      "100g gefrorene Mango",
      "50ml Kokosmilch",
      "Toppings: Granola, Kiwi, Erdbeeren, Kokosflocken"
    ],
    instructions:
      "Gefrorenen Squishee, Banane, Mango und Kokosmilch im Mixer cremig pürieren. In Bowl füllen. Mit Granola, Früchten und Kokosflocken garnieren. Sofort servieren!",
    prep_time: 10,
    difficulty: "leicht",
    servings: 2,
    image_url: "/images/rezept-smoothie-bowl.svg",
    tags: ["frühstück", "schnell", "vegan", "bunt"],
    seasonal: true,
    category_id: cat_schnell.id
  },
  %{
    title: "Bart's Scharfe Salsa mit Tortilla",
    description:
      "Ay caramba! Diese Salsa ist so scharf, dass selbst Chief Wiggum um Gnade bittet. Einfach zubereitet, unfassbar lecker.",
    ingredients: [
      "4 reife Tomaten",
      "1 rote Zwiebel",
      "2 Jalapeños",
      "1 Bund Koriander",
      "2 Limetten (Saft)",
      "1 Knoblauchzehe",
      "Salz",
      "Tortilla-Chips zum Servieren"
    ],
    instructions:
      "Tomaten, Zwiebel und Jalapeños fein würfeln. Knoblauch pressen. Koriander hacken. Alles vermengen, mit Limettensaft und Salz abschmecken. 30 Min. ziehen lassen. Mit Tortilla-Chips servieren.",
    prep_time: 15,
    difficulty: "leicht",
    servings: 4,
    image_url: "/images/rezept-salsa.svg",
    tags: ["snack", "scharf", "vegan", "schnell"],
    seasonal: false,
    category_id: cat_schnell.id
  },
  %{
    title: "Marge's Sonntagslasagne",
    description:
      "Die Lasagne, die Homer wieder nach Hause bringt. Marges berühmtes Familienrezept – in Springfield ein Heiligtum.",
    ingredients: [
      "500g Hackfleisch (gemischt)",
      "400g Lasagneblätter",
      "800g Tomatensauce",
      "500g Ricotta",
      "200g Mozzarella",
      "100g Parmesan gerieben",
      "1 Zwiebel",
      "3 Knoblauchzehen",
      "Oregano",
      "Basilikum"
    ],
    instructions:
      "Hackfleisch mit Zwiebel und Knoblauch anbraten. Tomatensauce zugeben, 15 Min. köcheln. Ricotta mit Kräutern mischen. Lasagne schichten: Sauce – Nudeln – Ricotta – Mozzarella. Wiederholen. Mit Parmesan abschließen. Bei 180°C, 45 Min. backen.",
    prep_time: 90,
    difficulty: "mittel",
    servings: 6,
    image_url: "/images/rezept-lasagne.svg",
    tags: ["hauptgericht", "pasta", "marge", "familienrezept"],
    seasonal: false,
    category_id: cat_homer.id
  },
  %{
    title: "Lisa's Veganer Springfield Burger",
    description:
      "Lisa beweist: Veganer Essen kann auch in Springfield lecker sein! Ihr Burger ist so gut, dass Homer ihn nicht bemerkt hat.",
    ingredients: [
      "2 Dosen Kichererbsen (abgetropft)",
      "1 rote Zwiebel",
      "2 Knoblauchzehen",
      "50g Haferflocken",
      "2 EL Tomatenmark",
      "1 TL Kreuzkümmel",
      "Paprikapulver",
      "Burgerbrötchen",
      "Salat, Tomate, Avocado"
    ],
    instructions:
      "Kichererbsen grob zerdrücken. Zwiebel und Knoblauch fein hacken, anschwitzen. Mit Erbsen, Haferflocken und Gewürzen zu einer Masse formen. Patties formen, 4 Min. pro Seite braten. Im Brötchen mit Beilagen servieren.",
    prep_time: 30,
    difficulty: "mittel",
    servings: 4,
    image_url: "/images/rezept-vegan-burger.svg",
    tags: ["vegan", "vegetarisch", "burger", "lisa"],
    seasonal: false,
    category_id: cat_veg.id
  },
  %{
    title: "Apu's Mango Lassi",
    description:
      "Das perfekte Kühlgetränk nach einer langen Schicht im Kwik-E-Mart. Apus Schwester hat dieses Rezept aus Bombay mitgebracht.",
    ingredients: [
      "2 reife Mangos",
      "400ml Joghurt (3,5% Fett)",
      "200ml Milch",
      "2 EL Zucker",
      "Prise Kardamom",
      "Eiswürfel",
      "Minze zum Garnieren"
    ],
    instructions:
      "Mango schälen und würfeln. Mit Joghurt, Milch, Zucker und Kardamom im Mixer cremig pürieren. Mit Eiswürfeln in hohe Gläser füllen. Mit Minze garnieren. Sofort servieren.",
    prep_time: 10,
    difficulty: "leicht",
    servings: 4,
    image_url: "/images/rezept-mango-lassi.svg",
    tags: ["getränk", "indisch", "erfrischend", "schnell"],
    seasonal: true,
    category_id: cat_schnell.id
  },
  %{
    title: "Homer's Chili con Carne",
    description:
      "Das Chili, das Homer bei der Springfield Chili-Kocherei einreicht. Vorsicht: enthält geheime Zutaten aus der Kwik-E-Mart-Pfefferabteilung.",
    ingredients: [
      "500g Rinderhackfleisch",
      "2 Dosen Kidneybohnen",
      "800g Tomaten",
      "2 Chipotle-Schoten",
      "2 Zwiebeln",
      "4 Knoblauchzehen",
      "2 EL Kreuzkümmel",
      "Chili-Pulver",
      "Dunkle Schokolade (1 Riegel)",
      "Saure Sahne, Cheddar zum Servieren"
    ],
    instructions:
      "Hackfleisch scharf anbraten. Zwiebeln und Knoblauch zugeben. Chipotle, Gewürze und Tomaten einrühren. Bohnen zugeben. 1 Std. auf kleiner Flamme köcheln. Schokolade einrühren. Mit Saurer Sahne und Cheddar servieren.",
    prep_time: 75,
    difficulty: "mittel",
    servings: 5,
    image_url: "/images/rezept-chili.svg",
    tags: ["hauptgericht", "scharf", "homer", "chili"],
    seasonal: false,
    category_id: cat_homer.id
  }
]

Enum.each(recipes_data, fn attrs ->
  %Recipe{} |> Recipe.changeset(attrs) |> Repo.insert!()
end)

IO.puts("""
✅ Seeds erfolgreich!
   #{length(markets)} Kwik-E-Mart Filialen
   #{length(offer_categories) + length(recipe_categories)} Kategorien
   #{length(offers_data)} Angebote
   #{length(recipes_data)} Rezepte
""")
