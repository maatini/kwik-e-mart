defmodule KwikEMartWeb.RecipeTeaserComponent do
  use KwikEMartWeb, :html

  attr :recipe, :map, required: true

  def recipe_teaser(assigns) do
    ~H"""
    <div class="recipe-card">
      <div class="relative bg-gray-100 h-48 flex items-center justify-center overflow-hidden">
        <%= if @recipe.seasonal do %>
          <div class="recipe-seasonal-badge">🌸 Saisonal</div>
        <% end %>
        <%= if @recipe.image_url do %>
          <img src={@recipe.image_url} alt={@recipe.title} class="w-full h-full object-contain p-4" />
        <% else %>
          <span class="text-6xl">🍽️</span>
        <% end %>
      </div>
      <div class="p-4 flex flex-col flex-1">
        <%= if @recipe.category do %>
          <p class="recipe-card-category"><%= @recipe.category.name %></p>
        <% end %>
        <h3 class="recipe-card-title mb-1"><%= @recipe.title %></h3>
        <p class="text-sm text-gray-600 mb-3 line-clamp-2"><%= @recipe.description %></p>
        <div class="recipe-card-meta mb-3">
          <%= if @recipe.prep_time do %>
            <span>⏱ <%= @recipe.prep_time %> Min.</span>
          <% end %>
          <%= if @recipe.difficulty do %>
            <span>·</span>
            <span><%= @recipe.difficulty %></span>
          <% end %>
          <%= if @recipe.servings do %>
            <span>·</span>
            <span><%= @recipe.servings %> Portionen</span>
          <% end %>
        </div>
        <div class="flex flex-wrap gap-1 mb-2">
          <%= for tag <- Enum.take(@recipe.tags, 3) do %>
            <span class="recipe-card-tag">#<%= tag %></span>
          <% end %>
        </div>
        <.link navigate={~p"/rezepte/live/#{@recipe.id}"} class="recipe-card-mehr">Mehr erfahren →</.link>
      </div>
    </div>
    """
  end
end
