defmodule KwikEMartWeb.RecipeTeaserComponent do
  use KwikEMartWeb, :html

  attr :recipe, :map, required: true

  def recipe_teaser(assigns) do
    ~H"""
    <div class="recipe-card">
      <div class="relative bg-gray-100 h-48 flex items-center justify-center">
        <%= if @recipe.seasonal do %>
          <div class="recipe-seasonal-badge">🌸 Saisonal</div>
        <% end %>
        <span class="text-6xl">🍽️</span>
      </div>
      <div class="p-4">
        <h3 class="font-bold text-gray-900 mb-1 line-clamp-2"><%= @recipe.title %></h3>
        <p class="text-sm text-gray-600 mb-3 line-clamp-2"><%= @recipe.description %></p>
        <div class="flex items-center gap-3 text-xs text-gray-500 mb-3">
          <%= if @recipe.prep_time do %>
            <span>⏱ <%= @recipe.prep_time %> Min.</span>
          <% end %>
          <%= if @recipe.category do %>
            <span><%= @recipe.category.icon %> <%= @recipe.category.name %></span>
          <% end %>
        </div>
        <div class="flex flex-wrap gap-1">
          <%= for tag <- Enum.take(@recipe.tags, 3) do %>
            <span class="recipe-card-tag">#<%= tag %></span>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
