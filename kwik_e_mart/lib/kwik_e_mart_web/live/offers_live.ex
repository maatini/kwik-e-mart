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
     |> assign(:page_title, "Wochenangebote – Kwik-E-Mart")}
  end

  @impl true
  def handle_params(%{"category" => cat_id}, _uri, socket) do
    market_id = socket.assigns[:current_market] && socket.assigns.current_market.id
    cat_id_int = String.to_integer(cat_id)
    offers = Offers.list_offers(market_id: market_id, category_id: cat_id_int)
    {:noreply, assign(socket, offers: offers, selected_category: cat_id_int)}
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

  defp format_price(nil), do: ""
  defp format_price(price) do
    :io_lib.format("~.2f", [Decimal.to_float(price)])
    |> to_string()
    |> String.replace(".", ",")
    |> Kernel.<>(" €")
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%!-- Page Header --%>
    <div class="kem-page-header">
      <div class="kem-page-header-inner">
        <div>
          <h1 class="kem-page-title">Wochenangebote</h1>
          <p class="text-sm text-gray-500 mt-1">Gültig bis Samstag – solange der Vorrat reicht</p>
        </div>
        <%= if @current_market do %>
          <a href={~p"/markt-waehlen"} class="flex items-center gap-2 text-sm font-medium text-kem-green hover:underline">
            <span class="text-base">📍</span>
            <span><%= @current_market.name %></span>
          </a>
        <% else %>
          <a href={~p"/markt-waehlen"} class="btn-outline-green text-sm py-2 px-4">
            Markt wählen
          </a>
        <% end %>
      </div>
    </div>

    <%!-- Category Filter --%>
    <div class="bg-white border-b border-gray-100">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-3">
        <div class="flex gap-2 overflow-x-auto pb-1 scrollbar-hide">
          <button
            phx-click="reset_filter"
            class={if(@selected_category == nil, do: "filter-pill filter-pill-active", else: "filter-pill filter-pill-inactive")}
          >
            Alle Angebote
          </button>
          <%= for cat <- @categories do %>
            <button
              phx-click="filter_category"
              phx-value-id={cat.id}
              class={if(@selected_category == cat.id, do: "filter-pill filter-pill-active", else: "filter-pill filter-pill-inactive")}
            >
              <%= cat.icon %> <%= cat.name %>
            </button>
          <% end %>
        </div>
      </div>
    </div>

    <%!-- Offer Grid --%>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <%= if @offers != [] do %>
        <div class="offer-grid">
          <%= for offer <- @offers do %>
            <div class="offer-card">
              <div class="offer-card-image">
                <%= if offer.discount_percent && offer.discount_percent >= 30 do %>
                  <div class="offer-card-badge-label">Superknüller</div>
                <% end %>
                <%= if offer.discount_percent do %>
                  <div class="offer-card-badge-discount">
                    -<%= offer.discount_percent %>%
                  </div>
                <% end %>
                <span class="text-5xl">🛒</span>
              </div>
              <div class="offer-card-body">
                <p class="offer-card-title"><%= offer.title %></p>
                <%= if offer.description do %>
                  <p class="offer-card-desc"><%= offer.description %></p>
                <% end %>
                <div class="offer-card-price-row">
                  <span class="offer-card-price"><%= format_price(offer.price) %></span>
                  <%= if offer.original_price do %>
                    <span class="offer-card-original"><%= format_price(offer.original_price) %></span>
                  <% end %>
                </div>
                <p class="offer-card-valid">bis <%= Calendar.strftime(offer.valid_to, "%d.%m.") %></p>
              </div>
            </div>
          <% end %>
        </div>
      <% else %>
        <div class="text-center py-20">
          <p class="text-4xl mb-4">🛒</p>
          <p class="text-xl font-bold text-gray-700 mb-2">Keine Angebote gefunden</p>
          <p class="text-gray-500 mb-6">Wähle einen anderen Filter oder such dir einen Markt in deiner Nähe.</p>
          <a href={~p"/markt-waehlen"} class="btn-primary">Markt wählen</a>
        </div>
      <% end %>
    </div>
    """
  end
end
