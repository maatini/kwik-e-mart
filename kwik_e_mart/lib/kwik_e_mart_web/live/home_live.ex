defmodule KwikEMartWeb.HomeLive do
  use KwikEMartWeb, :live_view

  alias KwikEMart.{Offers, Recipes, Markets}
  import KwikEMartWeb.PriceHelpers

  @impl true
  def mount(_params, session, socket) do
    market_id = session["market_id"]
    current_market = market_id && Markets.get_market(market_id)

    featured_offers = Offers.list_featured_offers(6)
    recipes = Recipes.list_recipes(limit: 3)

    {:ok,
     socket
     |> assign(:current_market, current_market)
     |> assign(:featured_offers, featured_offers)
     |> assign(:recipes, recipes)
     |> assign(:newsletter_subscribed, false)
     |> assign(:nav_active, :home)
     |> assign(:today, Date.utc_today())
     |> assign(:page_title, "Kwik-E-Mart Springfield – Thank you, come again!")}
  end

  @impl true
  def handle_event("subscribe_newsletter", %{"email" => email}, socket) when email != "" do
    {:noreply,
     socket
     |> assign(:newsletter_subscribed, true)
     |> put_flash(:info, "Danke! #{email} wurde angemeldet. Thank you, come again!")}
  end

  def handle_event("subscribe_newsletter", _params, socket) do
    {:noreply, put_flash(socket, :error, "Bitte eine gültige E-Mail-Adresse eingeben.")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%!-- ── HERO CAROUSEL ─────────────────────────────────────────── --%>
    <div class="kem-carousel">
      <div class="kem-carousel-track">
        <%!-- Slide 1: Summer Duff --%>
        <div class="kem-carousel-slide bg-kem-yellow">
          <div class="max-w-7xl mx-auto px-4 sm:px-8 lg:px-16 flex items-center justify-between w-full h-full">
            <div class="max-w-xl">
              <p class="text-kem-green font-black text-sm uppercase tracking-widest mb-2">
                🍺 Sommer-Special
              </p>
              <h1 class="text-4xl lg:text-6xl font-black text-kem-dark leading-tight mb-4">
                Duff Beer Saison!<br />
                <span class="text-kem-green">Bis zu 29% sparen</span>
              </h1>
              <p class="text-kem-dark/70 text-lg mb-6">
                Homer's Lieblingsgetränk – jetzt im Sommer-Angebot. Kalt stellen, fertig.
              </p>
              <.link navigate={~p"/angebote/live"} class="btn-primary inline-block">
                Zu den Angeboten →
              </.link>
            </div>
            <div class="hidden lg:block text-[160px] select-none leading-none">🍺</div>
          </div>
        </div>

        <%!-- Slide 2: Eigenmarken --%>
        <div class="kem-carousel-slide bg-kem-green">
          <div class="max-w-7xl mx-auto px-4 sm:px-8 lg:px-16 flex items-center justify-between w-full h-full">
            <div class="max-w-xl">
              <p class="text-kem-yellow font-black text-sm uppercase tracking-widest mb-2">
                ⭐ Unsere Marken
              </p>
              <h1 class="text-4xl lg:text-6xl font-black text-white leading-tight mb-4">
                Apu's Eigenmarken –<br />
                <span class="text-kem-yellow">Frisch. Günstig.</span>
              </h1>
              <p class="text-white/80 text-lg mb-6">
                Hergestellt in Springfield. Mit Liebe von Apu persönlich ausgewählt.
              </p>
              <.link navigate={~p"/angebote/live"} class="btn-secondary inline-block">
                Jetzt entdecken →
              </.link>
            </div>
            <div class="hidden lg:block text-[160px] select-none leading-none">🏪</div>
          </div>
        </div>

        <%!-- Slide 3: Rezepte --%>
        <div class="kem-carousel-slide bg-kem-dark">
          <div class="max-w-7xl mx-auto px-4 sm:px-8 lg:px-16 flex items-center justify-between w-full h-full">
            <div class="max-w-xl">
              <p class="text-kem-yellow font-black text-sm uppercase tracking-widest mb-2">
                🍛 Neue Rezepte
              </p>
              <h1 class="text-4xl lg:text-6xl font-black text-white leading-tight mb-4">
                Kochen wie Apu –<br />
                <span class="text-kem-yellow">Springfield-Küche</span>
              </h1>
              <p class="text-white/70 text-lg mb-6">
                Tikka Masala, Donut Pudding, Mango Lassi – alle Zutaten im Kwik-E-Mart.
              </p>
              <.link navigate={~p"/rezepte/live"} class="btn-primary inline-block">
                Rezepte entdecken →
              </.link>
            </div>
            <div class="hidden lg:block text-[160px] select-none leading-none">🍛</div>
          </div>
        </div>
      </div>

      <%!-- Carousel dots (decorative) --%>
      <div class="kem-carousel-dots">
        <div class="kem-carousel-dot"></div>
        <div class="kem-carousel-dot"></div>
        <div class="kem-carousel-dot"></div>
      </div>
    </div>

    <%!-- ── FEATURED OFFERS ──────────────────────────────────────── --%>
    <%= if @featured_offers != [] do %>
      <section class="kem-section bg-white">
        <div class="kem-section-inner">
          <div class="kem-section-header">
            <div>
              <h2 class="kem-section-title">Diese Woche besonders günstig</h2>
              <p class="kem-section-subtitle">Marge's persönliche Superknüller-Auswahl</p>
            </div>
            <.link navigate={~p"/angebote/live"} class="kem-section-link">
              Alle Angebote →
            </.link>
          </div>
          <div class="offer-grid">
            <%= for offer <- @featured_offers do %>
              <div class="offer-card">
                <div class="offer-card-image">
                  <%= if offer.discount_percent && offer.discount_percent >= 30 do %>
                    <div class="offer-card-badge-label">Superknüller</div>
                  <% end %>
                  <%= if offer.discount_percent && offer.discount_percent > 0 do %>
                    <div class="offer-card-badge-discount">-{offer.discount_percent}%</div>
                  <% end %>
                  <%= if offer.image_url do %>
                    <img
                      src={offer.image_url}
                      alt={offer.title}
                      class="w-full h-full object-contain p-4"
                    />
                  <% else %>
                    <span class="text-5xl">🛒</span>
                  <% end %>
                  <%= if Date.diff(offer.valid_to, @today) <= 3 do %>
                    <div class="offer-countdown-badge">
                      Noch {Date.diff(offer.valid_to, @today)} Tag{if Date.diff(
                                                                        offer.valid_to,
                                                                        @today
                                                                      ) != 1,
                                                                      do: "e"}
                    </div>
                  <% end %>
                </div>
                <div class="offer-card-body">
                  <p class="offer-card-title">{offer.title}</p>
                  <div class="offer-card-price-row">
                    <span class="offer-card-price">{format_price(offer.price)}</span>
                    <%= if offer.original_price do %>
                      <span class="offer-card-original">{format_price(offer.original_price)}</span>
                    <% end %>
                  </div>
                  <p class="offer-card-valid">Bis {Calendar.strftime(offer.valid_to, "%d.%m.%Y")}</p>
                </div>
              </div>
            <% end %>
          </div>
          <div class="text-center mt-8">
            <.link navigate={~p"/angebote/live"} class="btn-outline-green">
              Alle Wochenangebote ansehen
            </.link>
          </div>
        </div>
      </section>
    <% end %>

    <%!-- ── EIGENMARKEN STRIP ───────────────────────────────────────── --%>
    <div class="kem-brand-strip">
      <div class="kem-section-inner">
        <p class="text-center text-sm font-bold text-gray-500 uppercase tracking-widest mb-6">
          Unsere Eigenmarken
        </p>
        <div class="grid grid-cols-5 gap-4">
          <div class="kem-brand-item">
            <div class="kem-brand-icon">🥤</div>
            <span class="kem-brand-name">Squishee</span>
          </div>
          <div class="kem-brand-item">
            <div class="kem-brand-icon">🍺</div>
            <span class="kem-brand-name">Duff Beer</span>
          </div>
          <div class="kem-brand-item">
            <div class="kem-brand-icon">🥣</div>
            <span class="kem-brand-name">Krusty-O's</span>
          </div>
          <div class="kem-brand-item">
            <div class="kem-brand-icon">🍔</div>
            <span class="kem-brand-name">Ribwich</span>
          </div>
          <div class="kem-brand-item">
            <div class="kem-brand-icon">⭐</div>
            <span class="kem-brand-name">Apu's Wahl</span>
          </div>
        </div>
      </div>
    </div>

    <%!-- ── SEASONAL RECIPES ────────────────────────────────────────── --%>
    <%= if @recipes != [] do %>
      <section class="kem-section bg-gray-50">
        <div class="kem-section-inner">
          <div class="kem-section-header">
            <div>
              <h2 class="kem-section-title">Rezepte & Inspiration</h2>
              <p class="kem-section-subtitle">Kochen wie Apu – mit Zutaten aus dem Kwik-E-Mart</p>
            </div>
            <.link navigate={~p"/rezepte/live"} class="kem-section-link">
              Alle Rezepte →
            </.link>
          </div>
          <div class="recipe-grid">
            <%= for recipe <- @recipes do %>
              <div class="recipe-card group">
                <div class="recipe-card-image">
                  <div class="w-full h-full bg-kem-gray flex items-center justify-center">
                    <span class="text-6xl">🍽️</span>
                  </div>
                  <%= if recipe.seasonal do %>
                    <div class="recipe-card-seasonal">🌸 Saisonal</div>
                  <% end %>
                </div>
                <div class="recipe-card-body">
                  <%= if recipe.category do %>
                    <p class="recipe-card-category">{recipe.category.icon} {recipe.category.name}</p>
                  <% end %>
                  <h3 class="recipe-card-title">{recipe.title}</h3>
                  <p class="text-sm text-gray-600 mt-2 line-clamp-2">{recipe.description}</p>
                  <div class="recipe-card-meta mt-2">
                    <%= if recipe.prep_time do %>
                      <span>⏱ {recipe.prep_time} Min.</span>
                    <% end %>
                    <%= if recipe.difficulty do %>
                      <span>· {recipe.difficulty}</span>
                    <% end %>
                    <%= if recipe.servings do %>
                      <span>· {recipe.servings} Portionen</span>
                    <% end %>
                  </div>
                  <div class="mt-3 flex flex-wrap gap-1">
                    <%= for tag <- Enum.take(recipe.tags, 3) do %>
                      <span class="bg-gray-100 text-gray-600 text-xs px-2 py-0.5 rounded-full">
                        #{tag}
                      </span>
                    <% end %>
                  </div>
                  <.link navigate={~p"/rezepte/live/#{recipe.id}"} class="recipe-card-mehr">
                    Zum Rezept →
                  </.link>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </section>
    <% end %>

    <%!-- ── PROMO BANNER (Markt finden) ───────────────────────────── --%>
    <div class="kem-promo-banner">
      <div class="kem-promo-banner-inner">
        <div class="text-white">
          <h2 class="text-3xl lg:text-4xl font-black mb-3">Deinen Kwik-E-Mart finden</h2>
          <p class="text-white/80 text-lg">
            Wir sind an {5} Standorten in Springfield und Umgebung für dich da.
          </p>
        </div>
        <div class="flex flex-col sm:flex-row gap-3">
          <.link navigate={~p"/markt-waehlen"} class="btn-secondary whitespace-nowrap">
            📍 Markt wählen
          </.link>
          <%= if @current_market do %>
            <div class="bg-white/10 border border-white/20 text-white font-bold px-6 py-3 rounded-full text-sm whitespace-nowrap">
              ✓ {@current_market.name}
            </div>
          <% end %>
        </div>
      </div>
    </div>

    <%!-- ── SERVICE BLOCK ──────────────────────────────────────────── --%>
    <div class="kem-service-block">
      <div class="kem-section-inner">
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
          <.link navigate={~p"/angebote/live"} class="kem-service-item">
            <div class="kem-service-icon">🏷️</div>
            <div>
              <h3 class="font-bold text-gray-900 mb-1">Wochenangebote</h3>
              <p class="text-sm text-gray-500">
                Jeden Sonntag neue Deals – pünktlich um 03:00 Uhr Springfield-Zeit.
              </p>
            </div>
          </.link>
          <.link navigate={~p"/rezepte/live"} class="kem-service-item">
            <div class="kem-service-icon">🍽️</div>
            <div>
              <h3 class="font-bold text-gray-900 mb-1">Frische Rezepte</h3>
              <p class="text-sm text-gray-500">
                Von Apu persönlich kuratiert. Indisch, amerikanisch, vegetarisch.
              </p>
            </div>
          </.link>
          <.link navigate={~p"/markt-waehlen"} class="kem-service-item">
            <div class="kem-service-icon">📍</div>
            <div>
              <h3 class="font-bold text-gray-900 mb-1">Markt finden</h3>
              <p class="text-sm text-gray-500">
                PLZ, Stadt oder Geolocation – wir finden deinen nächsten Kwik-E-Mart.
              </p>
            </div>
          </.link>
        </div>
      </div>
    </div>

    <%!-- ── APP PROMO BANNER ────────────────────────────────────────── --%>
    <div class="kem-app-banner">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 flex flex-col md:flex-row items-center justify-between gap-8">
        <div class="text-white max-w-lg">
          <p class="text-kem-yellow font-black text-sm uppercase tracking-widest mb-2">
            📱 Springfield Mobile
          </p>
          <h2 class="text-3xl lg:text-4xl font-black mb-3">
            Hol dir die Kwik-E-Mart App
          </h2>
          <p class="text-white/70 text-lg mb-6">
            Angebote, Rezepte und Marktsuche – alles in einer App.
            Exklusiv für Springfield-Bewohner.
          </p>
          <div class="flex gap-3 flex-wrap">
            <span class="bg-white/10 border border-white/20 text-white font-bold px-5 py-2.5 rounded-full text-sm cursor-not-allowed opacity-60">
              📱 App Store – bald verfügbar
            </span>
            <span class="bg-white/10 border border-white/20 text-white font-bold px-5 py-2.5 rounded-full text-sm cursor-not-allowed opacity-60">
              🤖 Google Play – bald verfügbar
            </span>
          </div>
        </div>
        <div class="text-[120px] select-none">📱</div>
      </div>
    </div>

    <%!-- ── NEWSLETTER ───────────────────────────────────────────────── --%>
    <section class="kem-newsletter-section">
      <div class="kem-section-inner text-center">
        <h2 class="text-2xl lg:text-3xl font-black text-kem-dark mb-2">
          🗞️ Kwik-E-Mart Newsletter
        </h2>
        <p class="text-gray-500 text-lg mb-6">
          Jede Woche die besten Angebote direkt in dein Postfach. Kein Spam – nur Deals.
        </p>
        <%= if @newsletter_subscribed do %>
          <div class="inline-flex items-center gap-2 bg-kem-green/10 border border-kem-green text-kem-green font-bold px-6 py-3 rounded-full">
            ✓ Du bist dabei! Thank you, come again!
          </div>
        <% else %>
          <form
            phx-submit="subscribe_newsletter"
            class="flex flex-col sm:flex-row gap-3 max-w-md mx-auto"
          >
            <input
              type="email"
              name="email"
              placeholder="deine@email.de"
              required
              class="flex-1 border-2 border-gray-200 rounded-full px-5 py-3 text-base focus:border-kem-green focus:outline-none"
            />
            <button type="submit" class="btn-primary whitespace-nowrap">
              Jetzt anmelden
            </button>
          </form>
          <p class="text-xs text-gray-400 mt-3">
            Du kannst dich jederzeit wieder abmelden. Datenschutz wird in Springfield ernst genommen.
          </p>
        <% end %>
      </div>
    </section>
    """
  end
end
