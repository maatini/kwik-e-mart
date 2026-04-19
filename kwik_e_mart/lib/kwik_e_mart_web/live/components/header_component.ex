defmodule KwikEMartWeb.HeaderComponent do
  use KwikEMartWeb, :html

  attr :current_market, :map, default: nil
  attr :nav_active, :atom, default: nil

  def kem_nav(assigns) do
    ~H"""
    <header class="kem-nav">
      <div class="kem-nav-inner">
        <div class="flex items-center gap-8">
          <.link navigate="/" class="flex-shrink-0" aria-label="Kwik-E-Mart">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 72 52" class="h-10 w-auto" aria-hidden="true">
              <!-- Dach-Dreieck -->
              <polygon points="36,2 5,18 67,18" fill="white"/>
              <!-- Dach-Spitze Stern -->
              <polygon points="36,0 38,5 36,4 34,5" fill="#FFED00"/>
              <!-- Gelbes Markisendach -->
              <rect x="3" y="17" width="66" height="12" fill="#FFED00"/>
              <!-- Markisen-Schattenstreifen -->
              <rect x="3" y="26" width="66" height="3" fill="#d4c000"/>
              <!-- Weißer Gebäudekörper -->
              <rect x="5" y="28" width="62" height="22" fill="white" rx="1"/>
              <!-- Linkes Fenster -->
              <rect x="9" y="31" width="18" height="13" rx="1" fill="#c5e8f7"/>
              <line x1="18" y1="31" x2="18" y2="44" stroke="white" stroke-width="1.2"/>
              <line x1="9" y1="37.5" x2="27" y2="37.5" stroke="white" stroke-width="1.2"/>
              <!-- Rechtes Fenster -->
              <rect x="45" y="31" width="18" height="13" rx="1" fill="#c5e8f7"/>
              <line x1="54" y1="31" x2="54" y2="44" stroke="white" stroke-width="1.2"/>
              <line x1="45" y1="37.5" x2="63" y2="37.5" stroke="white" stroke-width="1.2"/>
              <!-- Tür (mittig) -->
              <rect x="28" y="34" width="16" height="16" rx="1" fill="#a8d8bc"/>
              <circle cx="39" cy="42" r="1.4" fill="white" opacity="0.9"/>
              <!-- "KEM" Schriftzug auf der Markise -->
              <text x="36" y="24.5" text-anchor="middle" font-family="Arial Black, Impact, sans-serif" font-weight="900" font-size="9" fill="#1a1a1a" letter-spacing="2.5">KEM</text>
            </svg>
          </.link>

          <nav class="hidden md:flex items-center gap-6">
            <.link navigate="/angebote/live" class={nav_link_class(@nav_active, :angebote)}>Angebote</.link>
            <.link navigate="/rezepte/live"  class={nav_link_class(@nav_active, :rezepte)}>Rezepte</.link>
            <.link navigate="/markt-waehlen" class={nav_link_class(@nav_active, :markt)}>Märkte</.link>
            <.link navigate="/"              class={nav_link_class(@nav_active, :mehr)}>Mehr erfahren</.link>
          </nav>
        </div>

        <div class="flex items-center gap-4">
          <.link navigate="/markt-waehlen" class="market-selector-btn hidden sm:flex">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
            <span class="text-xs leading-tight max-w-[120px] truncate">
              <%= if @current_market, do: @current_market.name, else: "Markt wählen" %>
            </span>
          </.link>

          <button class="text-white hover:text-kem-yellow transition-colors">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </button>

          <button class="text-white hover:text-kem-yellow transition-colors">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
          </button>
        </div>
      </div>
    </header>
    """
  end

  defp nav_link_class(active, key) when active == key, do: "kem-nav-link kem-nav-link-active"
  defp nav_link_class(_active, _key), do: "kem-nav-link"
end
