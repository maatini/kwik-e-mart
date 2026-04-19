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
     |> assign(:page_title, "Rezepte & Inspiration – Kwik-E-Mart")}
  end

  @impl true
  def handle_event("filter_category", %{"id" => id}, socket) do
    cat_id = String.to_integer(id)
    recipes = Recipes.list_recipes(category_id: cat_id)
    {:noreply, assign(socket, recipes: recipes, selected_category: cat_id, show_seasonal_only: false)}
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
    <%!-- Page Header --%>
    <div class="kem-page-header">
      <div class="kem-page-header-inner">
        <div>
          <h1 class="kem-page-title">Rezepte & Inspiration</h1>
          <p class="text-sm text-gray-500 mt-1">Kochen wie Apu – mit Zutaten aus dem Kwik-E-Mart</p>
        </div>
      </div>
    </div>

    <%!-- Filter Strip --%>
    <div class="bg-white border-b border-gray-100">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-3">
        <div class="flex gap-2 overflow-x-auto pb-1">
          <button
            phx-click="reset_filter"
            class={if(@selected_category == nil && !@show_seasonal_only, do: "filter-pill filter-pill-active", else: "filter-pill filter-pill-inactive")}
          >
            Alle Rezepte
          </button>
          <button
            phx-click="toggle_seasonal"
            class={if(@show_seasonal_only, do: "filter-pill filter-pill-active", else: "filter-pill filter-pill-inactive")}
          >
            🌸 Saisonal
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

    <%!-- Recipe Grid --%>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <%= if @recipes != [] do %>
        <div class="recipe-grid">
          <%= for recipe <- @recipes do %>
            <div class="recipe-card group">
              <div class="recipe-card-image">
                <div class="w-full h-full bg-kem-gray flex items-center justify-center">
                  <span class="text-6xl">🍽️</span>
                </div>
                <%= if recipe.seasonal do %>
                  <div class="recipe-card-seasonal">🌸 Saisonal</div>
                <% end %>
              </div>
              <div class="recipe-card-body">
                <%= if recipe.category do %>
                  <p class="recipe-card-category"><%= recipe.category.icon %> <%= recipe.category.name %></p>
                <% end %>
                <h3 class="recipe-card-title"><%= recipe.title %></h3>
                <p class="text-sm text-gray-600 mt-2 line-clamp-2"><%= recipe.description %></p>
                <div class="recipe-card-meta">
                  <%= if recipe.prep_time do %>
                    <span>⏱ <%= recipe.prep_time %> Min.</span>
                  <% end %>
                  <%= if recipe.ingredients do %>
                    <span><%= length(recipe.ingredients) %> Zutaten</span>
                  <% end %>
                </div>
                <%= if recipe.tags && recipe.tags != [] do %>
                  <div class="mt-3 flex flex-wrap gap-1">
                    <%= for tag <- Enum.take(recipe.tags, 3) do %>
                      <span class="bg-gray-100 text-gray-600 text-xs px-2 py-0.5 rounded-full">#<%= tag %></span>
                    <% end %>
                  </div>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>
      <% else %>
        <div class="text-center py-20">
          <p class="text-4xl mb-4">🍽️</p>
          <p class="text-xl font-bold text-gray-700 mb-2">Keine Rezepte gefunden</p>
          <p class="text-gray-500">Probiere einen anderen Filter.</p>
        </div>
      <% end %>
    </div>
    """
  end
end
