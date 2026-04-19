defmodule KwikEMartWeb.OfferCardComponent do
  use KwikEMartWeb, :html

  attr :offer, :map, required: true

  def offer_card(assigns) do
    ~H"""
    <div class="offer-card">
      <div class="relative bg-gray-50 h-40 flex items-center justify-center">
        <%= if @offer.discount_percent && @offer.discount_percent >= 30 do %>
          <div class="offer-card-badge-superknueller">Marge's Superknüller</div>
        <% end %>
        <%= if @offer.discount_percent do %>
          <div class="offer-card-badge-discount">
            <span class="text-xs leading-none text-center">
              -<%= @offer.discount_percent %><br/>%
            </span>
          </div>
        <% end %>
        <span class="text-5xl">🛒</span>
      </div>
      <div class="p-3">
        <p class="font-semibold text-gray-900 text-sm leading-tight mb-1 line-clamp-2">
          <%= @offer.title %>
        </p>
        <p class="text-xs text-gray-500 mb-2 line-clamp-2"><%= @offer.description %></p>
        <div class="flex items-baseline gap-1 flex-wrap">
          <span class="offer-card-price">
            <%= format_price(@offer.price) %>
          </span>
          <%= if @offer.original_price do %>
            <span class="offer-card-original-price"><%= format_price(@offer.original_price) %></span>
          <% end %>
        </div>
        <p class="text-xs text-gray-400 mt-1">
          gültig bis <%= format_date(@offer.valid_to) %>
        </p>
        <.link navigate={~p"/angebote/live"} class="text-xs font-semibold text-kem-green hover:underline mt-1 inline-block">
          Mehr erfahren →
        </.link>
      </div>
    </div>
    """
  end

  defp format_price(nil), do: ""
  defp format_price(%Decimal{} = price) do
    price
    |> Decimal.round(2)
    |> Decimal.to_string(:normal)
    |> String.replace(".", ",")
    |> Kernel.<>(" €")
  end

  defp format_date(%Date{} = date) do
    Calendar.strftime(date, "%d.%m.")
  end
  defp format_date(_), do: ""
end
