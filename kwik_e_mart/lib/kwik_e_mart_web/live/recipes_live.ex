defmodule KwikEMartWeb.RecipesLive do
  use KwikEMartWeb, :live_view

  alias KwikEMart.{Recipes, Offers}

  @impl true
  def mount(_params, _session, socket) do
    categories = Offers.list_categories("recipe")
    recipes = Recipes.list_recipes()

    {:ok,
     socket
     |> assign(:categories, categories)
     |> assign(:recipes, recipes)
     |> assign(:selected_category, nil)
     |> assign(:show_seasonal_only, false)
     |> assign(:page_title, "Rezepte – EDEKA")}
  end

  @impl true
  def handle_event("filter_category", %{"id" => id}, socket) do
    cat_id = String.to_integer(id)
    recipes = Recipes.list_recipes(category_id: cat_id)
    {:noreply, assign(socket, recipes: recipes, selected_category: cat_id)}
  end

  @impl true
  def handle_event("toggle_seasonal", _params, socket) do
    seasonal = !socket.assigns.show_seasonal_only
    recipes = if seasonal, do: Recipes.list_seasonal_recipes(), else: Recipes.list_recipes()
    {:noreply, assign(socket, recipes: recipes, show_seasonal_only: seasonal, selected_category: nil)}
  end

  @impl true
  def handle_event("reset_filter", _params, socket) do
    {:noreply, assign(socket, recipes: Recipes.list_recipes(), selected_category: nil, show_seasonal_only: false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-6xl mx-auto px-4 py-8">
      <h1 class="text-3xl font-bold text-edeka-green mb-6">Rezepte & Inspiration</h1>

      <div class="flex gap-2 mb-6 flex-wrap items-center">
        <button
          phx-click="reset_filter"
          class={["px-4 py-2 rounded-full text-sm font-medium transition-colors",
                  if(@selected_category == nil && !@show_seasonal_only, do: "bg-edeka-green text-white", else: "bg-gray-100 text-gray-700 hover:bg-gray-200")]}
        >
          Alle Rezepte
        </button>
        <button
          phx-click="toggle_seasonal"
          class={["px-4 py-2 rounded-full text-sm font-medium transition-colors",
                  if(@show_seasonal_only, do: "bg-edeka-yellow text-gray-900", else: "bg-gray-100 text-gray-700 hover:bg-gray-200")]}
        >
          🌸 Saisonal
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

      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <%= for recipe <- @recipes do %>
          <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-shadow">
            <div class="bg-gray-100 h-48 flex items-center justify-center relative">
              <%= if recipe.seasonal do %>
                <div class="absolute top-3 left-3 bg-edeka-yellow text-gray-900 text-xs font-bold px-2 py-1 rounded-full">
                  🌸 Saisonal
                </div>
              <% end %>
              <span class="text-6xl">🍽️</span>
            </div>
            <div class="p-4">
              <h3 class="font-bold text-gray-900 mb-1"><%= recipe.title %></h3>
              <p class="text-sm text-gray-600 mb-3 line-clamp-2"><%= recipe.description %></p>
              <div class="flex items-center gap-3 text-xs text-gray-500">
                <%= if recipe.prep_time do %>
                  <span>⏱ <%= recipe.prep_time %> Min.</span>
                <% end %>
                <%= if recipe.category do %>
                  <span><%= recipe.category.icon %> <%= recipe.category.name %></span>
                <% end %>
              </div>
              <div class="mt-3 flex flex-wrap gap-1">
                <%= for tag <- Enum.take(recipe.tags, 3) do %>
                  <span class="bg-gray-100 text-gray-600 text-xs px-2 py-0.5 rounded-full">#<%= tag %></span>
                <% end %>
              </div>
            </div>
          </div>
        <% end %>
      </div>

      <%= if @recipes == [] do %>
        <div class="text-center py-16 text-gray-500">
          <p class="text-lg">Keine Rezepte gefunden.</p>
        </div>
      <% end %>
    </div>
    """
  end
end
