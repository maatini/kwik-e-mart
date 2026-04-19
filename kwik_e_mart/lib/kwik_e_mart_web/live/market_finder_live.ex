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
     |> assign(:page_title, "Markt wählen – EDEKA")}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    results = Markets.search_markets(query)
    {:noreply, assign(socket, query: query, results: results)}
  end

  @impl true
  def handle_event("select_market", %{"id" => id}, socket) do
    market = Markets.get_market!(String.to_integer(id))

    {:noreply,
     socket
     |> assign(:current_market, market)
     |> put_flash(:info, "#{market.name} in #{market.city} ausgewählt")
     |> push_event("market_selected", %{market_id: market.id})}
  end

  @impl true
  def handle_event("use_location", %{"lat" => lat, "lng" => lng}, socket) do
    nearby = Markets.find_nearby_markets(lat, lng)
    {:noreply, assign(socket, results: nearby)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto px-4 py-8">
      <h1 class="text-3xl font-bold text-edeka-green mb-6">Deinen Markt wählen</h1>

      <%= if @current_market do %>
        <div class="bg-green-50 border border-edeka-green rounded-lg p-4 mb-6 flex items-center justify-between">
          <div>
            <p class="text-sm text-gray-500">Aktuell ausgewählt:</p>
            <p class="font-bold text-edeka-green"><%= @current_market.name %></p>
            <p class="text-sm text-gray-600"><%= @current_market.street %>, <%= @current_market.zip %> <%= @current_market.city %></p>
          </div>
          <span class="text-green-500 text-2xl">✓</span>
        </div>
      <% end %>

      <div class="mb-4">
        <button
          phx-click="use_location"
          phx-hook="Geolocation"
          id="geo-btn"
          class="w-full bg-edeka-yellow text-gray-900 font-semibold py-3 px-4 rounded-lg mb-3 hover:bg-yellow-400 transition-colors"
        >
          📍 Standort verwenden
        </button>
      </div>

      <form phx-change="search" class="mb-6">
        <input
          type="text"
          name="query"
          value={@query}
          placeholder="Stadt, PLZ oder Marktname..."
          class="w-full border-2 border-gray-200 rounded-lg px-4 py-3 text-lg focus:border-edeka-green focus:outline-none"
          autofocus
        />
      </form>

      <div class="space-y-3">
        <%= for market <- @results do %>
          <div class="border border-gray-200 rounded-lg p-4 hover:border-edeka-green cursor-pointer transition-colors"
               phx-click="select_market"
               phx-value-id={market.id}>
            <div class="flex items-center justify-between">
              <div>
                <p class="font-bold text-gray-900"><%= market.name %></p>
                <p class="text-sm text-gray-600"><%= market.street %></p>
                <p class="text-sm text-gray-600"><%= market.zip %> <%= market.city %></p>
              </div>
              <div class="text-edeka-green">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                </svg>
              </div>
            </div>
          </div>
        <% end %>

        <%= if @query != "" and @results == [] do %>
          <p class="text-gray-500 text-center py-8">Kein Markt gefunden. Bitte anderen Suchbegriff versuchen.</p>
        <% end %>
      </div>
    </div>
    """
  end
end
