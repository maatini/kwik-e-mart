defmodule KwikEMartWeb.MarketFinderLive do
  use KwikEMartWeb, :live_view

  alias KwikEMart.Markets

  @impl true
  def mount(_params, session, socket) do
    current_market_id = session["market_id"]
    current_market = current_market_id && Markets.get_market(current_market_id)

    {:ok,
     socket
     |> assign(:query, "")
     |> assign(:results, [])
     |> assign(:current_market, current_market)
     |> assign(:nav_active, :markt)
     |> assign(:page_title, "Markt wählen – Kwik-E-Mart")}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    results = Markets.search_markets(query)
    {:noreply,
     socket
     |> assign(query: query, results: results)
     |> push_event("update_map", %{markets: map_data(results)})}
  end

  @impl true
  def handle_event("select_market", %{"id" => id}, socket) do
    market = Markets.get_market!(String.to_integer(id))

    {:noreply,
     socket
     |> assign(:current_market, market)
     |> assign(:results, [])
     |> assign(:query, "")
     |> put_flash(:info, "#{market.name} in #{market.city} ausgewählt")
     |> push_event("market_selected", %{market_id: market.id})}
  end

  @impl true
  def handle_event("use_location", %{"lat" => lat, "lng" => lng}, socket) do
    nearby = Markets.find_nearby_markets(lat, lng)
    {:noreply,
     socket
     |> assign(results: nearby)
     |> push_event("update_map", %{markets: map_data(nearby)})}
  end

  def handle_event("use_location", _params, socket), do: {:noreply, socket}

  defp map_data(markets) do
    Enum.map(markets, fn m ->
      %{name: m.name, street: m.street, city: m.city, lat: m.latitude, lng: m.longitude}
    end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%!-- Page Header --%>
    <div class="kem-page-header">
      <div class="kem-page-header-inner">
        <div>
          <h1 class="kem-page-title">Deinen Kwik-E-Mart finden</h1>
          <p class="text-sm text-gray-500 mt-1">Wir sind überall in Springfield für dich da</p>
        </div>
      </div>
    </div>

    <div class="max-w-2xl mx-auto px-4 sm:px-6 py-8">

      <%!-- Current market banner --%>
      <%= if @current_market do %>
        <div class="bg-kem-green/5 border border-kem-green rounded-2xl p-5 mb-6 flex items-center justify-between">
          <div>
            <p class="text-xs font-bold text-kem-green uppercase tracking-wide mb-1">❤️ Dein Lieblingsmarkt</p>
            <p class="font-bold text-gray-900 text-lg"><%= @current_market.name %></p>
            <p class="text-sm text-gray-600">
              <%= @current_market.street %>, <%= @current_market.zip %> <%= @current_market.city %>
            </p>
          </div>
          <div class="w-10 h-10 rounded-full bg-kem-green flex items-center justify-center text-white text-xl shrink-0">
            ✓
          </div>
        </div>
      <% end %>

      <%!-- Geolocation button --%>
      <button
        phx-click="use_location"
        phx-hook="Geolocation"
        id="geo-btn"
        class="w-full flex items-center justify-center gap-3 bg-kem-yellow text-kem-dark font-bold py-4 px-6 rounded-2xl mb-4 hover:bg-yellow-300 transition-colors"
      >
        <span class="text-xl">📍</span>
        <span>Meinen Standort verwenden</span>
      </button>

      <%!-- Divider --%>
      <div class="flex items-center gap-3 mb-4">
        <div class="flex-1 h-px bg-gray-200"></div>
        <span class="text-xs text-gray-400 font-medium">oder suchen</span>
        <div class="flex-1 h-px bg-gray-200"></div>
      </div>

      <%!-- Search form --%>
      <form phx-change="search" class="mb-6">
        <div class="relative">
          <span class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 text-lg">🔍</span>
          <input
            type="text"
            name="query"
            value={@query}
            placeholder="Stadt, PLZ oder Marktname …"
            class="w-full border-2 border-gray-200 rounded-2xl pl-11 pr-4 py-4 text-base focus:border-kem-green focus:outline-none transition-colors"
            autofocus
          />
        </div>
      </form>

      <%!-- Map --%>
      <div
        id="market-map"
        phx-hook="LeafletMap"
        phx-update="ignore"
        class="w-full h-64 rounded-2xl overflow-hidden border border-gray-200 mb-6"
      ></div>

      <%!-- Results --%>
      <div class="space-y-3">
        <%= for market <- @results do %>
          <button
            phx-click="select_market"
            phx-value-id={market.id}
            class="w-full text-left border-2 border-gray-100 rounded-2xl p-4 hover:border-kem-green transition-colors group"
          >
            <div class="flex items-center justify-between">
              <div>
                <p class="font-bold text-gray-900 group-hover:text-kem-green transition-colors">
                  <%= market.name %>
                </p>
                <p class="text-sm text-gray-500 mt-0.5">
                  <%= market.street %>, <%= market.zip %> <%= market.city %>
                </p>
              </div>
              <div class="text-gray-300 group-hover:text-kem-green transition-colors shrink-0 ml-4">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                </svg>
              </div>
            </div>
          </button>
        <% end %>

        <%= if @query != "" and @results == [] do %>
          <div class="text-center py-12">
            <p class="text-3xl mb-3">🗺️</p>
            <p class="font-bold text-gray-700">Kein Markt gefunden</p>
            <p class="text-sm text-gray-500 mt-1">Versuche es mit einem anderen Suchbegriff.</p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
