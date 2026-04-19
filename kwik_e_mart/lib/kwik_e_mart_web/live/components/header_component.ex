defmodule KwikEMartWeb.HeaderComponent do
  use KwikEMartWeb, :html

  attr :current_market, :map, default: nil

  def header(assigns) do
    ~H"""
    <header class="kem-nav">
      <div class="kem-nav-inner">
        <div class="flex items-center gap-8">
          <.link navigate="/" class="flex-shrink-0">
            <div class="text-white font-black text-2xl tracking-tight">
              <span class="text-kem-yellow">K</span>wik-E-Mart
            </div>
          </.link>

          <nav class="hidden md:flex items-center gap-6">
            <.link navigate="/markt-waehlen" class="kem-nav-link">Angebote</.link>
            <.link navigate="/rezepte/live" class="kem-nav-link">Rezepte</.link>
            <.link navigate="/" class="kem-nav-link">Region</.link>
            <.link navigate="/" class="kem-nav-link">Mehr erfahren</.link>
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
end
