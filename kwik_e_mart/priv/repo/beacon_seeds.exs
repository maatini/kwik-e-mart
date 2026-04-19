alias Beacon.Content

# ---------------------------------------------------------------------------
# Layout
# ---------------------------------------------------------------------------

layout =
  Content.create_layout!(%{
    site: :edeka,
    title: "Kwik-E-Mart Standard",
    meta_tags: [
      %{"name" => "charset", "content" => "utf-8"},
      %{"name" => "viewport", "content" => "width=device-width, initial-scale=1"}
    ],
    template: ~S"""
    <!DOCTYPE html>
    <html lang="de" class="scroll-smooth">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title><%= @beacon_live_data[:page_title] || "Kwik-E-Mart Springfield" %></title>
        <link rel="stylesheet" href="/assets/app.css" />
        <script defer src="/assets/app.js"></script>
        <style>
          :root {
            --kem-yellow: #FFED00;
            --kem-green:  #00A651;
            --kem-red:    #E3001B;
            --kem-dark:   #1a1a1a;
          }
        </style>
      </head>
      <body class="bg-white font-sans text-gray-900">

        <!-- NAV -->
        <header class="sticky top-0 z-50 bg-[#FFED00] shadow-md">
          <nav class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-16">
              <a href="/" class="flex items-center gap-3">
                <span class="text-3xl font-black tracking-tight text-[#00A651]">Kwik-E-Mart</span>
                <span class="hidden sm:block text-xs text-gray-700 leading-tight">Springfield's Finest<br/>Convenience Store</span>
              </a>
              <div class="hidden md:flex items-center gap-6 text-sm font-semibold text-gray-800">
                <a href="/angebote/live" class="hover:text-[#00A651] transition-colors">Angebote</a>
                <a href="/rezepte/live" class="hover:text-[#00A651] transition-colors">Rezepte</a>
                <a href="/markt-waehlen" class="hover:text-[#00A651] transition-colors">Märkte</a>
                <a href="/markt-waehlen"
                   class="bg-[#00A651] text-white px-4 py-2 rounded-full text-xs font-bold hover:bg-green-700 transition-colors">
                  Markt wählen
                </a>
              </div>
            </div>
          </nav>
        </header>

        <!-- PAGE CONTENT -->
        <main>
          <%= @inner_content %>
        </main>

        <!-- FOOTER -->
        <footer class="bg-[#1a1a1a] text-gray-300 mt-16">
          <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 grid grid-cols-2 md:grid-cols-4 gap-8">
            <div>
              <p class="text-[#FFED00] font-black text-xl mb-3">Kwik-E-Mart</p>
              <p class="text-xs leading-relaxed">
                Springfield's einziger<br/>24/7 Nahversorger seit 1989.
              </p>
            </div>
            <div>
              <p class="text-white font-semibold mb-3">Shop</p>
              <ul class="space-y-2 text-sm">
                <li><a href="/angebote/live" class="hover:text-[#FFED00]">Wochenangebote</a></li>
                <li><a href="/rezepte/live" class="hover:text-[#FFED00]">Rezepte</a></li>
              </ul>
            </div>
            <div>
              <p class="text-white font-semibold mb-3">Service</p>
              <ul class="space-y-2 text-sm">
                <li><a href="/markt-waehlen" class="hover:text-[#FFED00]">Markt finden</a></li>
              </ul>
            </div>
            <div>
              <p class="text-white font-semibold mb-3">Öffnungszeiten</p>
              <p class="text-sm">Täglich<br/>
                <span class="text-[#FFED00] font-bold">0:00 – 24:00 Uhr</span>
              </p>
            </div>
          </div>
          <div class="border-t border-gray-700 text-center py-4 text-xs text-gray-500">
            © 2026 Kwik-E-Mart Springfield · „Thank you, come again!"
          </div>
        </footer>

      </body>
    </html>
    """
  })

IO.puts("✅ Layout erstellt: #{layout.id}")

# ---------------------------------------------------------------------------
# Startseite
# ---------------------------------------------------------------------------

page =
  Content.create_page!(%{
    site: :edeka,
    path: "/",
    title: "Willkommen im Kwik-E-Mart",
    layout_id: layout.id,
    meta_tags: [
      %{"name" => "description", "content" => "Kwik-E-Mart Springfield – Ihr 24/7 Nahversorger. Squishees, Krusty-O's, Duff Beer und mehr."}
    ],
    template: ~S"""
    <%!-- HERO --%>
    <section class="relative overflow-hidden bg-[#FFED00]">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 lg:py-24 flex flex-col lg:flex-row items-center gap-10">

        <!-- Text -->
        <div class="flex-1 text-center lg:text-left">
          <p class="inline-block bg-[#E3001B] text-white text-xs font-bold px-3 py-1 rounded-full mb-4 uppercase tracking-wider">
            Seit 1989 in Springfield
          </p>
          <h1 class="text-5xl lg:text-7xl font-black text-[#1a1a1a] leading-none mb-4">
            Thank you,<br/>
            <span class="text-[#00A651]">come again!</span>
          </h1>
          <p class="text-lg text-gray-700 mb-8 max-w-md">
            Springfields beliebtester Convenience Store.<br/>
            Squishees, Krusty-O's, Lotterie &amp; mehr – rund um die Uhr.
          </p>
          <div class="flex flex-col sm:flex-row gap-3 justify-center lg:justify-start">
            <a href="/angebote/live"
               class="bg-[#00A651] text-white font-bold px-8 py-3 rounded-full hover:bg-green-700 transition-colors text-center">
              Wochenangebote
            </a>
            <a href="/markt-waehlen"
               class="bg-white text-[#1a1a1a] font-bold px-8 py-3 rounded-full border-2 border-[#1a1a1a] hover:bg-gray-100 transition-colors text-center">
              Markt finden
            </a>
          </div>
        </div>

        <!-- Apu Illustration (SVG placeholder) -->
        <div class="flex-shrink-0 w-72 h-72 lg:w-96 lg:h-96 relative">
          <div class="w-full h-full rounded-3xl bg-white/60 flex flex-col items-center justify-center text-center p-6 shadow-xl border-4 border-[#00A651]">
            <div class="text-8xl mb-3">🏪</div>
            <p class="font-black text-2xl text-[#00A651]">Kwik-E-Mart</p>
            <p class="text-sm text-gray-600 mt-1">„Ich bin bereit, Sie zu bedienen!"</p>
            <p class="text-xs text-gray-400 mt-2">— Apu Nahasapeemapetilon</p>
          </div>
        </div>

      </div>

      <!-- Dekorative Welle -->
      <svg class="absolute bottom-0 left-0 w-full" viewBox="0 0 1440 60" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M0 60L1440 60L1440 20C1200 60 960 0 720 20C480 40 240 0 0 20L0 60Z" fill="white"/>
      </svg>
    </section>

    <%!-- TOP-PRODUKTE --%>
    <section class="py-16 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-10">
          <h2 class="text-3xl font-black text-[#1a1a1a]">Unsere Spezialitäten</h2>
          <p class="text-gray-500 mt-2">Das Beste aus dem Kwik-E-Mart – täglich frisch!</p>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-4 gap-6">

          <!-- Squishee -->
          <div class="group bg-gradient-to-b from-[#FFED00]/20 to-white rounded-2xl p-6 text-center border-2 border-transparent hover:border-[#FFED00] transition-all shadow-sm hover:shadow-md">
            <div class="text-6xl mb-3">🥤</div>
            <h3 class="font-bold text-lg">Squishee</h3>
            <p class="text-sm text-gray-500 mt-1">Der Original Slush aus Springfield in 12 Geschmacksrichtungen</p>
            <p class="mt-3 text-[#00A651] font-black text-xl">ab 0,99 €</p>
          </div>

          <!-- Krusty-O's -->
          <div class="group bg-gradient-to-b from-[#E3001B]/10 to-white rounded-2xl p-6 text-center border-2 border-transparent hover:border-[#E3001B] transition-all shadow-sm hover:shadow-md">
            <div class="text-6xl mb-3">🥣</div>
            <h3 class="font-bold text-lg">Krusty-O's</h3>
            <p class="text-sm text-gray-500 mt-1">Das Frühstücks-Cerealien von Krusty dem Clown</p>
            <p class="mt-3 text-[#00A651] font-black text-xl">2,49 €</p>
          </div>

          <!-- Duff Beer -->
          <div class="group bg-gradient-to-b from-[#00A651]/10 to-white rounded-2xl p-6 text-center border-2 border-transparent hover:border-[#00A651] transition-all shadow-sm hover:shadow-md">
            <div class="text-6xl mb-3">🍺</div>
            <h3 class="font-bold text-lg">Duff Beer</h3>
            <p class="text-sm text-gray-500 mt-1">Homers Lieblingsgetränk – kalt und frisch</p>
            <p class="mt-3 text-[#00A651] font-black text-xl">1,29 €</p>
          </div>

          <!-- Hot Dogs -->
          <div class="group bg-gradient-to-b from-orange-100 to-white rounded-2xl p-6 text-center border-2 border-transparent hover:border-orange-300 transition-all shadow-sm hover:shadow-md">
            <div class="text-6xl mb-3">🌭</div>
            <h3 class="font-bold text-lg">Hot Dog</h3>
            <p class="text-sm text-gray-500 mt-1">Seit 3 Tagen auf der Rolle – garantiert warm</p>
            <p class="mt-3 text-[#00A651] font-black text-xl">1,79 €</p>
          </div>

        </div>
      </div>
    </section>

    <%!-- ANGEBOTE BANNER --%>
    <section class="bg-[#00A651] py-14">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col md:flex-row items-center justify-between gap-6">
        <div class="text-white text-center md:text-left">
          <p class="text-sm font-semibold uppercase tracking-widest opacity-75 mb-1">Diese Woche</p>
          <h2 class="text-3xl font-black">Wochenangebote entdecken</h2>
          <p class="mt-2 opacity-80">Frische Ware zu Springfield-Preisen – nur solange der Vorrat reicht!</p>
        </div>
        <a href="/angebote/live"
           class="flex-shrink-0 bg-[#FFED00] text-[#1a1a1a] font-black px-8 py-4 rounded-full text-lg hover:bg-yellow-300 transition-colors shadow-lg">
          Alle Angebote →
        </a>
      </div>
    </section>

    <%!-- APU ZITAT --%>
    <section class="py-16 bg-gray-50">
      <div class="max-w-3xl mx-auto px-4 text-center">
        <div class="text-6xl mb-4">🙏</div>
        <blockquote class="text-2xl font-black text-[#1a1a1a] leading-tight mb-4">
          „Ich bin hergekommen als einfacher Immigrant mit einem Doktortitel in Ingenieurswesen. Und jetzt leite ich einen der begehrtesten Convenience Stores in ganz Springfield."
        </blockquote>
        <p class="text-gray-500 font-semibold">— Apu Nahasapeemapetilon, Inhaber &amp; Chefverkäufer</p>
      </div>
    </section>

    <%!-- REZEPTE TEASER --%>
    <section class="py-16 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-end justify-between mb-8">
          <div>
            <h2 class="text-3xl font-black text-[#1a1a1a]">Rezepte aus Springfield</h2>
            <p class="text-gray-500 mt-1">Auch Apu kocht – hier sind seine Lieblingsrezepte</p>
          </div>
          <a href="/rezepte/live" class="hidden md:block text-[#00A651] font-semibold hover:underline">
            Alle Rezepte →
          </a>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
          <div class="rounded-2xl overflow-hidden border border-gray-100 shadow-sm hover:shadow-md transition-shadow">
            <div class="h-40 bg-gradient-to-br from-[#FFED00] to-orange-300 flex items-center justify-center text-6xl">🥣</div>
            <div class="p-4">
              <span class="text-xs font-bold text-[#00A651] uppercase tracking-wide">Frühstück</span>
              <h3 class="font-bold mt-1">Krusty-O's Milchbrei</h3>
              <p class="text-sm text-gray-500 mt-1">10 Min. • einfach</p>
            </div>
          </div>
          <div class="rounded-2xl overflow-hidden border border-gray-100 shadow-sm hover:shadow-md transition-shadow">
            <div class="h-40 bg-gradient-to-br from-green-200 to-[#00A651]/40 flex items-center justify-center text-6xl">🌭</div>
            <div class="p-4">
              <span class="text-xs font-bold text-[#00A651] uppercase tracking-wide">Snack</span>
              <h3 class="font-bold mt-1">Kwik-E-Mart Hot Dog Deluxe</h3>
              <p class="text-sm text-gray-500 mt-1">5 Min. • sehr einfach</p>
            </div>
          </div>
          <div class="rounded-2xl overflow-hidden border border-gray-100 shadow-sm hover:shadow-md transition-shadow">
            <div class="h-40 bg-gradient-to-br from-blue-100 to-purple-200 flex items-center justify-center text-6xl">🥤</div>
            <div class="p-4">
              <span class="text-xs font-bold text-[#00A651] uppercase tracking-wide">Getränk</span>
              <h3 class="font-bold mt-1">Squishee Cocktail</h3>
              <p class="text-sm text-gray-500 mt-1">2 Min. • kinderleicht</p>
            </div>
          </div>
        </div>

        <div class="text-center mt-8 md:hidden">
          <a href="/rezepte/live" class="text-[#00A651] font-semibold hover:underline">Alle Rezepte →</a>
        </div>
      </div>
    </section>

    <%!-- STORE INFO --%>
    <section class="py-16 bg-[#FFED00]">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
        <div>
          <div class="text-5xl mb-3">🕐</div>
          <h3 class="font-black text-xl text-[#1a1a1a]">24/7 geöffnet</h3>
          <p class="text-gray-700 mt-1 text-sm">Jeden Tag, auch Sonn- und Feiertage.<br/>Weil Springfield nie schläft.</p>
        </div>
        <div>
          <div class="text-5xl mb-3">📍</div>
          <h3 class="font-black text-xl text-[#1a1a1a]">Ihr Markt</h3>
          <p class="text-gray-700 mt-1 text-sm">Finden Sie den nächsten<br/>Kwik-E-Mart in Ihrer Nähe.</p>
          <a href="/markt-waehlen" class="inline-block mt-3 text-[#00A651] font-bold text-sm hover:underline">Markt wählen →</a>
        </div>
        <div>
          <div class="text-5xl mb-3">🎰</div>
          <h3 class="font-black text-xl text-[#1a1a1a]">Lotterie & Mehr</h3>
          <p class="text-gray-700 mt-1 text-sm">Lottoscheine, Zeitungen, Zigarren.<br/>Alles unter einem Dach.</p>
        </div>
      </div>
    </section>
    """
  })

Beacon.Content.publish_page(page)

IO.puts("✅ Startseite erstellt und veröffentlicht: #{page.id}")
