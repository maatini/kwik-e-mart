defmodule KwikEMartWeb.OffersLive do
  use KwikEMartWeb, :live_view

  alias KwikEMart.{Offers, Markets}

  @impl true
  def mount(_params, session, socket) do
    market_id = session["market_id"]
    current_market = market_id && Markets.get_market(market_id)
    categories = Offers.list_categories("offer")
    offers = Offers.list_offers(market_id: market_id)

    {:ok,
     socket
     |> assign(:current_market, current_market)
     |> assign(:categories, categories)
     |> assign(:offers, offers)
     |> assign(:selected_category, nil)
     |> assign(:page_title, "Angebote – EDEKA")}
  end

  @impl true
  def handle_params(%{"category" => cat_id}, _uri, socket) do
    market_id = socket.assigns[:current_market] && socket.assigns.current_market.id
    offers = Offers.list_offers(market_id: market_id, category_id: String.to_integer(cat_id))
    {:noreply, assign(socket, offers: offers, selected_category: String.to_integer(cat_id))}
  end

  def handle_params(_params, _uri, socket), do: {:noreply, socket}

  @impl true
  def handle_event("filter_category", %{"id" => id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/angebote/live?category=#{id}")}
  end

  @impl true
  def handle_event("reset_filter", _params, socket) do
    market_id = socket.assigns[:current_market] && socket.assigns.current_market.id
    offers = Offers.list_offers(market_id: market_id)
    {:noreply, assign(socket, offers: offers, selected_category: nil)}
  end

  defp format_price(price) when is_nil(price), do: ""
  defp format_price(price) do
    decimal = Decimal.to_float(price)
    formatted = :io_lib.format("~.2f", [decimal]) |> to_string() |> String.replace(".", ",")
    "#{formatted} €"
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-6xl mx-auto px-4 py-8">
      <div class="flex items-center justify-between mb-6">
        <h1 class="text-3xl font-bold text-edeka-green">Angebote der Woche</h1>
        <%= if @current_market do %>
          <span class="text-sm text-gray-600 bg-green-50 border border-edeka-green rounded-full px-3 py-1">
            📍 <%= @current_market.name %>
          </span>
        <% else %>
          <.link navigate={~p"/markt-waehlen"} class="text-sm text-edeka-green underline">
            Markt wählen
          </.link>
        <% end %>
      </div>

      <div class="flex gap-2 mb-6 flex-wrap">
        <button
          phx-click="reset_filter"
          class={["px-4 py-2 rounded-full text-sm font-medium transition-colors",
                  if(@selected_category == nil, do: "bg-edeka-green text-white", else: "bg-gray-100 text-gray-700 hover:bg-gray-200")]}
        >
          Alle
        </button>
        <%= for cat <- @categories do %>
          <button
            phx-click="filter_category"
            phx-value-id={cat.id}
            class={["px-4 py-2 rounded-full text-sm font-medium transition-colors",
                    if(@selected_category == cat.id, do: "bg-edeka-green text-white", else: "bg-gray-100 text-gray-700 hover:bg-gray-200")]}
          >
            <%= cat.icon %> <%= cat.name %>
          </button>
        <% end %>
      </div>

      <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
        <%= for offer <- @offers do %>
          <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-shadow">
            <div class="relative bg-gray-50 h-40 flex items-center justify-center">
              <%= if offer.discount_percent && offer.discount_percent >= 30 do %>
                <div class="absolute top-2 left-2 bg-edeka-green text-white text-xs font-bold px-2 py-1 rounded-full">
                  SUPERKNÜLLER
                </div>
              <% end %>
              <%= if offer.discount_percent do %>
                <div class="absolute top-2 right-2 bg-edeka-yellow text-gray-900 text-sm font-bold px-2 py-1 rounded-full">
                  -<%= offer.discount_percent %>%
                </div>
              <% end %>
              <span class="text-5xl">🛒</span>
            </div>
            <div class="p-3">
              <p class="font-semibold text-gray-900 text-sm leading-tight mb-1"><%= offer.title %></p>
              <p class="text-xs text-gray-500 mb-2 line-clamp-2"><%= offer.description %></p>
              <div class="flex items-baseline gap-2">
                <span class="text-xl font-bold text-edeka-green"><%= format_price(offer.price) %></span>
                <%= if offer.original_price do %>
                  <span class="text-xs text-gray-400 line-through"><%= format_price(offer.original_price) %></span>
                <% end %>
              </div>
              <p class="text-xs text-gray-400 mt-1">bis <%= Calendar.strftime(offer.valid_to, "%d.%m.") %></p>
            </div>
          </div>
        <% end %>
      </div>

      <%= if @offers == [] do %>
        <div class="text-center py-16 text-gray-500">
          <p class="text-lg">Keine Angebote gefunden.</p>
          <.link navigate={~p"/markt-waehlen"} class="text-edeka-green underline mt-2 inline-block">
            Markt wählen für lokale Angebote
          </.link>
        </div>
      <% end %>
    </div>
    """
  end
end
