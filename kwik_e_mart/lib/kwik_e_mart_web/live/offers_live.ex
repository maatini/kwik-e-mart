defmodule KwikEMartWeb.OffersLive do
  use KwikEMartWeb, :live_view

  alias KwikEMart.{Offers, Markets}
  import KwikEMartWeb.PriceHelpers

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
     |> assign(:date_range, valid_range(offers))
     |> assign(:selected_category, nil)
     |> assign(:superknueller_only, false)
     |> assign(:nav_active, :angebote)
     |> assign(:today, Date.utc_today())
     |> assign(:page_title, "Wochenangebote – Kwik-E-Mart")}
  end

  @impl true
  def handle_params(%{"superknueller" => "true"}, _uri, socket) do
    market_id = socket.assigns[:current_market] && socket.assigns.current_market.id
    offers = Offers.list_offers(market_id: market_id, superknueller: true)
    {:noreply, assign(socket, offers: offers, date_range: valid_range(offers), selected_category: nil, superknueller_only: true)}
  end

  def handle_params(%{"category" => cat_id}, _uri, socket) do
    case Integer.parse(cat_id) do
      {cat_id_int, ""} ->
        market_id = socket.assigns[:current_market] && socket.assigns.current_market.id
        offers = Offers.list_offers(market_id: market_id, category_id: cat_id_int)
        {:noreply, assign(socket, offers: offers, date_range: valid_range(offers), selected_category: cat_id_int, superknueller_only: false)}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_params(_params, _uri, socket), do: {:noreply, socket}

  @impl true
  def handle_event("filter_category", %{"id" => id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/angebote/live?category=#{id}")}
  end

  def handle_event("toggle_superknueller", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/angebote/live?superknueller=true")}
  end

  def handle_event("reset_filter", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/angebote/live")}
  end

  defp valid_range([]), do: nil
  defp valid_range(offers) do
    from = offers |> Enum.map(& &1.valid_from) |> Enum.min(Date)
    to   = offers |> Enum.map(& &1.valid_to)   |> Enum.max(Date)
    "#{Calendar.strftime(from, "%d.%m.%Y")} – #{Calendar.strftime(to, "%d.%m.%Y")}"
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%!-- Page Header --%>
    <div class="kem-page-header">
      <div class="kem-page-header-inner">
        <div>
          <h1 class="kem-page-title">
            <%= if @current_market do %>
              Deine Angebote für <%= @current_market.name %>
            <% else %>
              Alle Angebote in Springfield
            <% end %>
          </h1>
          <%= if @date_range do %>
            <p class="text-sm text-gray-500 mt-1">
              Gültig <%= @date_range %> · Nur in teilnehmenden Märkten
            </p>
          <% end %>
        </div>
        <div class="flex items-center gap-3">
          <button
            disabled
            title="Demnächst verfügbar"
            class="hidden sm:flex items-center gap-2 text-sm font-medium text-gray-300 border border-gray-100 rounded-full px-4 py-2 cursor-not-allowed"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
            </svg>
            Alle als PDF
          </button>
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
    </div>

    <%!-- Filter Pills --%>
    <div class="bg-white border-b border-gray-100">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-3">
        <div class="flex gap-2 overflow-x-auto pb-1 scrollbar-hide">
          <button
            phx-click="reset_filter"
            class={if(!@selected_category && !@superknueller_only, do: "filter-pill filter-pill-active", else: "filter-pill filter-pill-inactive")}
          >
            Alle Angebote
          </button>
          <button
            phx-click="toggle_superknueller"
            class={if(@superknueller_only, do: "filter-pill filter-pill-active", else: "filter-pill filter-pill-inactive")}
          >
            ⭐ Marge's Superknüller
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
                  <div class="offer-card-badge-label">Marge's Superknüller</div>
                <% end %>
                <%= if offer.discount_percent do %>
                  <div class="offer-card-badge-discount">
                    -<%= offer.discount_percent %>%
                  </div>
                <% end %>
                <%= if offer.image_url do %>
                  <img src={offer.image_url} alt={offer.title} class="w-full h-full object-contain p-4" />
                <% else %>
                  <span class="text-5xl">🛒</span>
                <% end %>
                <%= if Date.diff(offer.valid_to, @today) <= 3 do %>
                  <div class="offer-countdown-badge">
                    Noch <%= Date.diff(offer.valid_to, @today) %> Tag<%= if Date.diff(offer.valid_to, @today) != 1, do: "e" %>
                  </div>
                <% end %>
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
                <p class="offer-card-valid">Bis <%= Calendar.strftime(offer.valid_to, "%d.%m.%Y") %></p>
              </div>
            </div>
          <% end %>
        </div>
        <p class="text-xs text-gray-400 text-center mt-6">
          *Nur in teilnehmenden Märkten. Solange der Vorrat reicht.
        </p>
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
