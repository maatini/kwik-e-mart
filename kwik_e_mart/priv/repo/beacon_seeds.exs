alias Beacon.Content

# ---------------------------------------------------------------------------
# Layout
# ---------------------------------------------------------------------------

layout_template = ~S"""
    <%!-- NAVIGATION --%>
    <nav class="kem-nav">
      <div class="kem-nav-inner">

        <%!-- Logo --%>
        <a href="/" class="flex items-center gap-3 shrink-0">
          <span class="kem-nav-logo">Kwik-E-Mart</span>
          <span class="hidden lg:block text-gray-400 text-xs leading-tight">
            Springfield's Finest<br/>Convenience Store
          </span>
        </a>

        <%!-- Desktop Nav --%>
        <div class="hidden md:flex items-center gap-6">
          <a href="/angebote/live" class="kem-nav-link">Angebote</a>
          <a href="/rezepte/live"  class="kem-nav-link">Rezepte</a>
          <a href="/#eigenmarken" class="kem-nav-link">Eigenmarken</a>
          <a href="/markt-waehlen" class="kem-nav-link">Märkte</a>
        </div>

        <%!-- Right: Markt CTA --%>
        <div class="flex items-center gap-3">
          <a href="/markt-waehlen" class="kem-nav-cta">
            📍 Markt wählen
          </a>
        </div>

      </div>
    </nav>

    <%!-- PAGE CONTENT --%>
    <main>
      <%= @inner_content %>
    </main>

    <%!-- FOOTER --%>
    <footer class="kem-footer">
      <div class="kem-footer-inner">
        <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-8 mb-10">

          <div class="col-span-2 md:col-span-1">
            <p class="text-kem-yellow font-black text-xl mb-3">Kwik-E-Mart</p>
            <p class="text-gray-400 text-xs leading-relaxed mb-4">
              Springfields einziger 24/7-Nahversorger<br/>seit 1989. Betrieben von<br/>Apu Nahasapeemapetilon.
            </p>
            <div class="flex gap-3">
              <a href="#" class="w-8 h-8 rounded-full bg-white/10 flex items-center justify-center hover:bg-white/20 transition-colors text-sm">f</a>
              <a href="#" class="w-8 h-8 rounded-full bg-white/10 flex items-center justify-center hover:bg-white/20 transition-colors text-sm">ig</a>
            </div>
          </div>

          <div>
            <p class="kem-footer-title">Einkaufen</p>
            <ul class="space-y-2">
              <li><a href="/angebote/live"  class="kem-footer-link">Wochenangebote</a></li>
              <li><a href="/rezepte/live"   class="kem-footer-link">Rezepte</a></li>
              <li><a href="/#eigenmarken"   class="kem-footer-link">Eigenmarken</a></li>
            </ul>
          </div>

          <div>
            <p class="kem-footer-title">Service</p>
            <ul class="space-y-2">
              <li><a href="/markt-waehlen"  class="kem-footer-link">Markt finden</a></li>
              <li><a href="#"               class="kem-footer-link">Newsletter</a></li>
              <li><a href="#"               class="kem-footer-link">Lotterie</a></li>
              <li><a href="#"               class="kem-footer-link">Öffnungszeiten</a></li>
            </ul>
          </div>

          <div>
            <p class="kem-footer-title">Springfield-Welt</p>
            <ul class="space-y-2">
              <li><a href="#" class="kem-footer-link">Über uns</a></li>
              <li><a href="#" class="kem-footer-link">Apu's Blog</a></li>
              <li><a href="#" class="kem-footer-link">Jobs</a></li>
              <li><a href="#" class="kem-footer-link">Presse</a></li>
            </ul>
          </div>

          <div>
            <p class="kem-footer-title">App & Mehr</p>
            <div class="bg-white/10 rounded-xl p-3 text-center">
              <p class="text-xs text-gray-400 mb-2">Kwik-E-Mart App</p>
              <div class="text-3xl mb-1">📱</div>
              <p class="text-xs text-gray-500">Demnächst im<br/>App Store</p>
            </div>
          </div>

        </div>

        <div class="border-t border-white/10 pt-6 flex flex-col md:flex-row items-center justify-between gap-3">
          <p class="text-xs text-gray-600">© 2026 Kwik-E-Mart Inc., Springfield · Alle Rechte vorbehalten</p>
          <p class="text-xs text-gray-600 italic">„Thank you, come again!" — Apu Nahasapeemapetilon</p>
        </div>
      </div>
    </footer>
"""

layout =
  case Content.list_layouts(:kwik) |> Enum.find(&(&1.title == "Kwik-E-Mart Standard")) do
    %Content.Layout{} = existing ->
      IO.puts("⏭  Layout aktualisieren…")
      {:ok, updated} = Content.update_layout(existing, %{
        template: layout_template,
        resource_links: [
          %{"rel" => "preconnect", "href" => "https://fonts.googleapis.com"},
          %{"rel" => "preconnect", "href" => "https://fonts.gstatic.com", "crossorigin" => ""},
          %{"rel" => "stylesheet", "href" => "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;900&display=swap"},
          %{"rel" => "stylesheet", "href" => "/assets/app.css"}
        ]
      })
      updated

    nil ->
      l = Content.create_layout!(%{
        site: :kwik,
        title: "Kwik-E-Mart Standard",
        template: layout_template,
        resource_links: [
          %{"rel" => "preconnect", "href" => "https://fonts.googleapis.com"},
          %{"rel" => "preconnect", "href" => "https://fonts.gstatic.com", "crossorigin" => ""},
          %{"rel" => "stylesheet", "href" => "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;900&display=swap"},
          %{"rel" => "stylesheet", "href" => "/assets/app.css"}
        ]
      })
      Content.publish_layout(l)
      IO.puts("✅ Layout erstellt + veröffentlicht: #{l.id}")
      l
  end

Content.publish_layout(layout)
IO.puts("✅ Layout veröffentlicht: #{layout.id}")

# ---------------------------------------------------------------------------
# Startseite
# ---------------------------------------------------------------------------

page_template = ~S"""
<%!-- =====================================================
     HERO KARUSSELL
     ===================================================== --%>
<div class="kem-carousel">
  <div class="kem-carousel-track">

    <%!-- Slide 1: Squishee --%>
    <div class="kem-carousel-slide bg-[#FFED00]">
      <div class="max-w-7xl mx-auto px-6 lg:px-8 w-full flex flex-col lg:flex-row items-center gap-8 lg:gap-16">
        <div class="flex-1 text-center lg:text-left">
          <span class="inline-block bg-[#E3001B] text-white text-xs font-bold px-3 py-1 rounded-full mb-4 uppercase tracking-wider">
            Sommer-Special
          </span>
          <h1 class="text-4xl lg:text-6xl font-black text-[#1a1a1a] leading-tight mb-3">
            Squishee<br/>
            <span class="text-[#00A651]">Tropical</span>
          </h1>
          <p class="text-gray-700 text-lg mb-6">0,5l – jetzt nur <strong>0,99 €</strong> statt 1,49 €</p>
          <a href="/angebote/live" class="btn-outline-green">Zum Angebot →</a>
        </div>
        <div class="text-8xl lg:text-9xl">🥤</div>
      </div>
    </div>

    <%!-- Slide 2: Duff Beer --%>
    <div class="kem-carousel-slide bg-[#00A651]">
      <div class="max-w-7xl mx-auto px-6 lg:px-8 w-full flex flex-col lg:flex-row items-center gap-8 lg:gap-16">
        <div class="flex-1 text-center lg:text-left">
          <span class="inline-block bg-[#FFED00] text-[#1a1a1a] text-xs font-bold px-3 py-1 rounded-full mb-4 uppercase tracking-wider">
            Wochenangebot
          </span>
          <h1 class="text-4xl lg:text-6xl font-black text-white leading-tight mb-3">
            Duff Beer<br/>
            <span class="text-[#FFED00]">6-Pack</span>
          </h1>
          <p class="text-white/80 text-lg mb-6">Nur <strong class="text-white">4,99 €</strong> – Homers Lieblingsgetränk!</p>
          <a href="/angebote/live" class="btn-primary">Jetzt kaufen →</a>
        </div>
        <div class="text-8xl lg:text-9xl">🍺</div>
      </div>
    </div>

    <%!-- Slide 3: Krusty-O's --%>
    <div class="kem-carousel-slide bg-[#E3001B]">
      <div class="max-w-7xl mx-auto px-6 lg:px-8 w-full flex flex-col lg:flex-row items-center gap-8 lg:gap-16">
        <div class="flex-1 text-center lg:text-left">
          <span class="inline-block bg-white text-[#E3001B] text-xs font-bold px-3 py-1 rounded-full mb-4 uppercase tracking-wider">
            Frühstücks-Hit
          </span>
          <h1 class="text-4xl lg:text-6xl font-black text-white leading-tight mb-3">
            Krusty-O's<br/>
            <span class="text-[#FFED00]">500g</span>
          </h1>
          <p class="text-white/80 text-lg mb-6">Nur <strong class="text-white">2,49 €</strong> statt 3,99 €</p>
          <a href="/angebote/live" class="btn-primary">Zum Angebot →</a>
        </div>
        <div class="text-8xl lg:text-9xl">🥣</div>
      </div>
    </div>

  </div>

  <%!-- Dots --%>
  <div class="kem-carousel-dots">
    <div class="kem-carousel-dot"></div>
    <div class="kem-carousel-dot"></div>
    <div class="kem-carousel-dot"></div>
  </div>
</div>

<%!-- =====================================================
     DEIN LIEBLINGSMARKT (prominent, direkt unter Hero)
     ===================================================== --%>
<section class="bg-[#00A651] py-10 lg:py-14">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex flex-col md:flex-row items-center justify-between gap-8">
      <div class="text-center md:text-left">
        <p class="text-[#FFED00] font-bold uppercase tracking-widest text-xs mb-2">Persönlich für dich</p>
        <h2 class="text-white text-3xl lg:text-4xl font-black leading-tight mb-3">
          DEIN LIEBLINGSMARKT
        </h2>
        <p class="text-white/80 text-base lg:text-lg max-w-lg">
          Speichere deinen Lieblings-Kwik-E-Mart und sieh sofort
          die Angebote für Springfield – ganz persönlich für dich.
        </p>
      </div>
      <a href="/markt-waehlen" class="btn-primary shrink-0 text-base lg:text-lg px-8 py-4 whitespace-nowrap">
        📍 MARKT WÄHLEN
      </a>
    </div>
  </div>
</section>

<%!-- =====================================================
     ANGEBOTE DER WOCHE
     ===================================================== --%>
<section class="kem-section bg-white">
  <div class="kem-section-inner">

    <div class="kem-section-header">
      <div>
        <h2 class="kem-section-title">Angebote der Woche</h2>
        <p class="kem-section-subtitle">Gültig 19.04.2026 – 03.05.2026 · Nur in teilnehmenden Märkten</p>
      </div>
      <a href="/angebote/live" class="kem-section-link">Alle Angebote →</a>
    </div>

    <div class="offer-grid">

      <div class="offer-card">
        <div class="offer-card-image bg-yellow-50">
          <div class="text-6xl">🥤</div>
          <div class="offer-card-badge-discount">-34%</div>
          <div class="offer-card-badge-label">Marge's Superknüller</div>
        </div>
        <div class="offer-card-body">
          <p class="offer-card-title">Squishee Tropical 0,5l</p>
          <div class="offer-card-price-row">
            <span class="offer-card-price">0,99 €</span>
            <span class="offer-card-original">1,49 €</span>
          </div>
          <p class="offer-card-valid">Bis 03.05.2026</p>
        </div>
      </div>

      <div class="offer-card">
        <div class="offer-card-image bg-amber-50">
          <div class="text-6xl">🍺</div>
          <div class="offer-card-badge-discount">-29%</div>
        </div>
        <div class="offer-card-body">
          <p class="offer-card-title">Duff Beer 6-Pack 0,33l</p>
          <div class="offer-card-price-row">
            <span class="offer-card-price">4,99 €</span>
            <span class="offer-card-original">6,99 €</span>
          </div>
          <p class="offer-card-valid">Bis 03.05.2026</p>
        </div>
      </div>

      <div class="offer-card">
        <div class="offer-card-image bg-red-50">
          <div class="text-6xl">🥣</div>
          <div class="offer-card-badge-discount">-38%</div>
          <div class="offer-card-badge-label">Marge's Superknüller</div>
        </div>
        <div class="offer-card-body">
          <p class="offer-card-title">Krusty-O's Cerealien 500g</p>
          <div class="offer-card-price-row">
            <span class="offer-card-price">2,49 €</span>
            <span class="offer-card-original">3,99 €</span>
          </div>
          <p class="offer-card-valid">Bis 03.05.2026</p>
        </div>
      </div>

      <div class="offer-card">
        <div class="offer-card-image bg-orange-50">
          <div class="text-6xl">🌭</div>
          <div class="offer-card-badge-discount">-28%</div>
        </div>
        <div class="offer-card-body">
          <p class="offer-card-title">Kwik-E-Mart Hot Dog</p>
          <div class="offer-card-price-row">
            <span class="offer-card-price">1,79 €</span>
            <span class="offer-card-original">2,49 €</span>
          </div>
          <p class="offer-card-valid">Bis 03.05.2026</p>
        </div>
      </div>

      <div class="offer-card">
        <div class="offer-card-image bg-pink-50">
          <div class="text-6xl">🍩</div>
          <div class="offer-card-badge-discount">-33%</div>
          <div class="offer-card-badge-label">Marge's Superknüller</div>
        </div>
        <div class="offer-card-body">
          <p class="offer-card-title">Springfield Donuts 6 Stück</p>
          <div class="offer-card-price-row">
            <span class="offer-card-price">1,99 €</span>
            <span class="offer-card-original">2,99 €</span>
          </div>
          <p class="offer-card-valid">Bis 03.05.2026</p>
        </div>
      </div>

      <div class="offer-card">
        <div class="offer-card-image bg-purple-50">
          <div class="text-6xl">🍔</div>
          <div class="offer-card-badge-discount">-30%</div>
          <div class="offer-card-badge-label">Limitiert</div>
        </div>
        <div class="offer-card-body">
          <p class="offer-card-title">Ribwich Burger (limitiert)</p>
          <div class="offer-card-price-row">
            <span class="offer-card-price">3,49 €</span>
            <span class="offer-card-original">4,99 €</span>
          </div>
          <p class="offer-card-valid">Bis 03.05.2026</p>
        </div>
      </div>

    </div>

    <div class="text-center mt-8 md:hidden">
      <a href="/angebote/live" class="btn-outline-green">Alle Angebote ansehen</a>
    </div>

  </div>
</section>

<%!-- =====================================================
     REZEPT-INSPIRATION
     ===================================================== --%>
<section class="kem-section bg-gray-50">
  <div class="kem-section-inner">

    <div class="kem-section-header">
      <div>
        <h2 class="kem-section-title">Auf der Suche nach Rezept-Inspiration?</h2>
        <p class="kem-section-subtitle">Gekocht von Apu, Homer, Marge, Bart und Lisa</p>
      </div>
      <a href="/rezepte/live" class="kem-section-link">Alle Rezepte →</a>
    </div>

    <div class="recipe-grid">

      <div class="recipe-card group">
        <div class="recipe-card-image bg-orange-100">
          <div class="flex items-center justify-center h-full text-7xl">🍛</div>
          <span class="recipe-card-seasonal">🌟 Apu's Klassiker</span>
        </div>
        <div class="recipe-card-body">
          <p class="recipe-card-category">Apu's Küche · Indisch</p>
          <h3 class="recipe-card-title">Apu's Chicken Tikka Masala</h3>
          <div class="recipe-card-meta">
            <span>⏱ 45 Min.</span>
            <span>·</span>
            <span>Hauptgericht</span>
            <span>·</span>
            <span>4 Portionen</span>
          </div>
        </div>
      </div>

      <div class="recipe-card group">
        <div class="recipe-card-image bg-pink-100">
          <div class="flex items-center justify-center h-full text-7xl">🍩</div>
        </div>
        <div class="recipe-card-body">
          <p class="recipe-card-category">Homer's Favourites · Dessert</p>
          <h3 class="recipe-card-title">Homer's Donut Bread Pudding</h3>
          <div class="recipe-card-meta">
            <span>⏱ 60 Min.</span>
            <span>·</span>
            <span>Süßspeise</span>
            <span>·</span>
            <span>6 Portionen</span>
          </div>
        </div>
      </div>

      <div class="recipe-card group">
        <div class="recipe-card-image bg-green-100">
          <div class="flex items-center justify-center h-full text-7xl">🥤</div>
          <span class="recipe-card-seasonal">☀️ Saisonal</span>
        </div>
        <div class="recipe-card-body">
          <p class="recipe-card-category">Schnell &amp; Einfach · Frühstück</p>
          <h3 class="recipe-card-title">Squishee Smoothie Bowl</h3>
          <div class="recipe-card-meta">
            <span>⏱ 10 Min.</span>
            <span>·</span>
            <span>Vegan</span>
            <span>·</span>
            <span>2 Portionen</span>
          </div>
        </div>
      </div>

      <div class="recipe-card group">
        <div class="recipe-card-image bg-red-100">
          <div class="flex items-center justify-center h-full text-7xl">🌶️</div>
        </div>
        <div class="recipe-card-body">
          <p class="recipe-card-category">Homer's Favourites · Hauptgericht</p>
          <h3 class="recipe-card-title">Homer's Chili con Carne</h3>
          <div class="recipe-card-meta">
            <span>⏱ 75 Min.</span>
            <span>·</span>
            <span>Scharf</span>
            <span>·</span>
            <span>5 Portionen</span>
          </div>
        </div>
      </div>

    </div>

    <div class="text-center mt-8">
      <a href="/rezepte/live" class="btn-outline-green">Alle Rezepte ansehen</a>
    </div>

  </div>
</section>

<%!-- =====================================================
     SAISONALER TEASER (Apu's Tipp)
     ===================================================== --%>
<section class="kem-section bg-[#FFED00]">
  <div class="kem-section-inner">
    <div class="flex flex-col lg:flex-row items-center gap-10 lg:gap-20">

      <div class="text-6xl lg:text-8xl shrink-0">🛒</div>

      <div class="flex-1 text-center lg:text-left">
        <span class="inline-block bg-[#E3001B] text-white text-xs font-bold px-3 py-1 rounded-full mb-4 uppercase tracking-wider">
          Apu's Tipp der Woche
        </span>
        <h2 class="text-3xl lg:text-5xl font-black text-[#1a1a1a] leading-tight mb-4">
          Curry-Paste &amp; Chai –<br/>Indien trifft Springfield
        </h2>
        <p class="text-gray-700 text-lg mb-6 max-w-xl">
          Apus Familienrezepte direkt aus Rahgul. Jetzt in Ihrem Kwik-E-Mart –
          authentisch, würzig und zu unschlagbaren Preisen.
        </p>
        <div class="flex flex-wrap gap-3 justify-center lg:justify-start">
          <a href="/angebote/live" class="btn-outline-green">Zu den Eigenmarken</a>
          <a href="/rezepte/live"  class="btn-primary">Apu's Rezepte</a>
        </div>
      </div>

    </div>
  </div>
</section>

<%!-- =====================================================
     EIGENMARKEN STRIP
     ===================================================== --%>
<section class="kem-brand-strip" id="eigenmarken">
  <div class="kem-section-inner">

    <div class="kem-section-header">
      <div>
        <h2 class="kem-section-title">Unsere Eigenmarken</h2>
        <p class="kem-section-subtitle">Aus Springfield – für Springfield. Qualität die Apu persönlich prüft.</p>
      </div>
    </div>

    <div class="grid grid-cols-3 sm:grid-cols-5 lg:grid-cols-6 gap-6">

      <div class="kem-brand-item">
        <div class="kem-brand-icon">🥤</div>
        <p class="kem-brand-name">Squishee</p>
        <p class="text-xs text-gray-400">Slush Drinks</p>
      </div>

      <div class="kem-brand-item">
        <div class="kem-brand-icon">🍺</div>
        <p class="kem-brand-name">Duff Beer</p>
        <p class="text-xs text-gray-400">Bier</p>
      </div>

      <div class="kem-brand-item">
        <div class="kem-brand-icon">🥣</div>
        <p class="kem-brand-name">Krusty-O's</p>
        <p class="text-xs text-gray-400">Cerealien</p>
      </div>

      <div class="kem-brand-item">
        <div class="kem-brand-icon">🥤</div>
        <p class="kem-brand-name">Buzz Cola</p>
        <p class="text-xs text-gray-400">Softdrinks</p>
      </div>

      <div class="kem-brand-item">
        <div class="kem-brand-icon">🍛</div>
        <p class="kem-brand-name">Apu's Spices</p>
        <p class="text-xs text-gray-400">Gewürze</p>
      </div>

      <div class="kem-brand-item">
        <div class="kem-brand-icon">🍩</div>
        <p class="kem-brand-name">Springfield<br/>Bakery</p>
        <p class="text-xs text-gray-400">Backwaren</p>
      </div>

    </div>

  </div>
</section>

<%!-- =====================================================
     NEWSLETTER-TEASER
     ===================================================== --%>
<section class="bg-[#1a1a1a] py-14">
  <div class="max-w-2xl mx-auto px-4 text-center">
    <p class="text-[#FFED00] text-xs font-bold uppercase tracking-widest mb-3">Newsletter</p>
    <h2 class="text-white text-3xl font-black mb-3">Kwik-E-Mart News</h2>
    <p class="text-gray-400 mb-8">
      Jetzt abonnieren und Duff-Beer-Rezepte, Wochenangebote
      und Apu's Weisheiten direkt ins Postfach!
    </p>
    <div class="flex flex-col sm:flex-row gap-3 max-w-md mx-auto">
      <input
        type="email"
        placeholder="Deine E-Mail-Adresse"
        class="flex-1 px-5 py-3 rounded-full text-gray-900 text-sm border-0 focus:ring-2 focus:ring-kem-green"
      />
      <button type="button" class="btn-primary whitespace-nowrap">Abonnieren →</button>
    </div>
    <p class="text-xs text-gray-600 mt-4">Marge weiß Bescheid – wir schützen deine Daten.</p>
  </div>
</section>

<%!-- =====================================================
     GEWINNSPIEL-BANNER
     ===================================================== --%>
<section class="bg-[#FFED00] py-12">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex flex-col md:flex-row items-center gap-8">
      <div class="text-7xl shrink-0">🍩</div>
      <div class="flex-1 text-center md:text-left">
        <p class="text-[#E3001B] font-bold uppercase tracking-widest text-xs mb-2">Gewinnspiel</p>
        <h2 class="text-[#1a1a1a] text-3xl font-black mb-2">
          Gewinne Homer's Lieblings-Doughnuts!
        </h2>
        <p class="text-gray-700 mb-4 max-w-lg">
          Kaufe für mind. 10 € ein und nimm an der wöchentlichen Verlosung teil.
          Der Gewinner erhält ein Jahr lang gratis Donuts vom Springfield Bakery!
        </p>
        <a href="#" class="btn-outline-green">Jetzt mitmachen →</a>
      </div>
    </div>
  </div>
</section>

<%!-- =====================================================
     SERVICE BLOCK
     ===================================================== --%>
<section class="kem-service-block">
  <div class="kem-section-inner">

    <h2 class="kem-section-title text-center mb-10">Unser Service</h2>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">

      <div class="kem-service-item">
        <div class="kem-service-icon">📍</div>
        <h3 class="font-bold text-gray-900">Markt finden</h3>
        <p class="text-sm text-gray-500">5 Filialen in und um Springfield – eine davon ist in Ihrer Nähe.</p>
        <a href="/markt-waehlen" class="text-kem-green font-semibold text-sm hover:underline mt-auto">Jetzt suchen →</a>
      </div>

      <div class="kem-service-item">
        <div class="kem-service-icon">🎰</div>
        <h3 class="font-bold text-gray-900">Lotterie</h3>
        <p class="text-sm text-gray-500">Lotto, Rubbellose, Krusty-Jackpot – täglich neue Chancen auf den großen Gewinn.</p>
        <a href="/angebote/live" class="text-kem-green font-semibold text-sm hover:underline mt-auto">Lose ansehen →</a>
      </div>

      <div class="kem-service-item">
        <div class="kem-service-icon">📰</div>
        <h3 class="font-bold text-gray-900">Springfield Shopper</h3>
        <p class="text-sm text-gray-500">Die Springfield-Zeitung – täglich frisch im Kwik-E-Mart. Auch digital.</p>
        <a href="#" class="text-kem-green font-semibold text-sm hover:underline mt-auto">Mehr erfahren →</a>
      </div>

      <div class="kem-service-item">
        <div class="kem-service-icon">🕐</div>
        <h3 class="font-bold text-gray-900">24/7 geöffnet</h3>
        <p class="text-sm text-gray-500">Weil Springfield nie schläft. Täglich von 0:00 bis 24:00 Uhr für Sie da.</p>
        <a href="/markt-waehlen" class="text-kem-green font-semibold text-sm hover:underline mt-auto">Filiale wählen →</a>
      </div>

    </div>

  </div>
</section>

<%!-- =====================================================
     APU ZITAT (Abschluss)
     ===================================================== --%>
<section class="bg-[#FFED00] py-14">
  <div class="max-w-3xl mx-auto px-4 text-center">
    <div class="text-5xl mb-5">🙏</div>
    <blockquote class="text-xl lg:text-2xl font-black text-[#1a1a1a] leading-snug mb-4">
      „Ich habe einen Doktortitel in Ingenieurswesen aus dem Siebenten Institut für
      Technologie in Kalkutta. Und dennoch bediene ich Sie hier mit Stolz – täglich, 24 Stunden."
    </blockquote>
    <p class="text-gray-600 font-semibold text-sm">— Apu Nahasapeemapetilon, Inhaber Kwik-E-Mart Springfield</p>
  </div>
</section>
"""

page =
  case Content.get_page_by(:kwik, path: "/") do
    %Content.Page{} = existing ->
      IO.puts("⏭  Seite aktualisieren…")
      {:ok, updated} = Content.update_page(existing, %{
        template: page_template,
        layout_id: layout.id
      })
      updated

    nil ->
      p = Content.create_page!(%{
        site: :kwik,
        path: "/",
        title: "Willkommen im Kwik-E-Mart",
        layout_id: layout.id,
        meta_tags: [
          %{"name" => "description",
            "content" => "Kwik-E-Mart Springfield – Ihr 24/7 Nahversorger. Squishees, Krusty-O's, Duff Beer und mehr."}
        ],
        template: page_template
      })
      IO.puts("✅ Seite erstellt: #{p.id}")
      p
  end

Content.publish_page(page)
IO.puts("✅ Startseite veröffentlicht.")
