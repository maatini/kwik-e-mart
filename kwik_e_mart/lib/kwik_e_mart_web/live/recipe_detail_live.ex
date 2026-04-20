defmodule KwikEMartWeb.RecipeDetailLive do
  use KwikEMartWeb, :live_view

  alias KwikEMart.Recipes

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    recipe = Recipes.get_recipe!(id)

    {:ok,
     socket
     |> assign(:recipe, recipe)
     |> assign(:nav_active, :rezepte)
     |> assign(:page_title, "#{recipe.title} – Kwik-E-Mart")}
  rescue
    Ecto.NoResultsError ->
      {:ok,
       socket
       |> put_flash(:error, "Rezept nicht gefunden.")
       |> redirect(to: ~p"/rezepte/live")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%!-- Back navigation --%>
    <div class="bg-white border-b border-gray-100">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-3">
        <.link
          navigate={~p"/rezepte/live"}
          class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-kem-green transition-colors"
        >
          ← Alle Rezepte
        </.link>
      </div>
    </div>

    <%!-- Recipe Hero --%>
    <div class="bg-white">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="flex flex-col md:flex-row gap-8">
          <%!-- Image --%>
          <div class="w-full md:w-80 flex-shrink-0">
            <div class="aspect-square bg-gray-100 rounded-2xl flex items-center justify-center overflow-hidden">
              <%= if @recipe.image_url do %>
                <img src={@recipe.image_url} alt={@recipe.title} class="w-full h-full object-cover" />
              <% else %>
                <span class="text-8xl">🍽️</span>
              <% end %>
            </div>
          </div>

          <%!-- Meta --%>
          <div class="flex-1 min-w-0">
            <%= if @recipe.seasonal do %>
              <span class="inline-block bg-kem-yellow text-kem-dark text-xs font-bold px-3 py-1 rounded-full mb-3">
                🌸 Saisonal
              </span>
            <% end %>
            <%= if @recipe.category do %>
              <p class="recipe-card-category mb-1">{@recipe.category.icon} {@recipe.category.name}</p>
            <% end %>
            <h1 class="text-3xl lg:text-4xl font-black text-kem-dark leading-tight mb-3">
              {@recipe.title}
            </h1>
            <%= if @recipe.description do %>
              <p class="text-gray-600 text-lg mb-5 leading-relaxed">{@recipe.description}</p>
            <% end %>

            <%!-- Stats row --%>
            <div class="flex flex-wrap gap-4 mb-5">
              <%= if @recipe.prep_time do %>
                <div class="flex items-center gap-2 bg-gray-50 rounded-xl px-4 py-2">
                  <span class="text-xl">⏱</span>
                  <div>
                    <p class="text-xs text-gray-400 font-medium uppercase">Zubereitungszeit</p>
                    <p class="font-bold text-gray-800">{@recipe.prep_time} Min.</p>
                  </div>
                </div>
              <% end %>
              <%= if @recipe.difficulty do %>
                <div class="flex items-center gap-2 bg-gray-50 rounded-xl px-4 py-2">
                  <span class="text-xl">📊</span>
                  <div>
                    <p class="text-xs text-gray-400 font-medium uppercase">Schwierigkeitsgrad</p>
                    <p class="font-bold text-gray-800 capitalize">{@recipe.difficulty}</p>
                  </div>
                </div>
              <% end %>
              <%= if @recipe.servings do %>
                <div class="flex items-center gap-2 bg-gray-50 rounded-xl px-4 py-2">
                  <span class="text-xl">👥</span>
                  <div>
                    <p class="text-xs text-gray-400 font-medium uppercase">Portionen</p>
                    <p class="font-bold text-gray-800">{@recipe.servings}</p>
                  </div>
                </div>
              <% end %>
            </div>

            <%!-- Tags --%>
            <%= if @recipe.tags && @recipe.tags != [] do %>
              <div class="flex flex-wrap gap-2">
                <%= for tag <- @recipe.tags do %>
                  <span class="bg-gray-100 text-gray-600 text-xs px-3 py-1 rounded-full">#{tag}</span>
                <% end %>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>

    <%!-- Ingredients + Instructions --%>
    <div class="bg-gray-50 py-10">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <%!-- Ingredients --%>
          <%= if @recipe.ingredients && @recipe.ingredients != [] do %>
            <div class="md:col-span-1">
              <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 sticky top-24">
                <h2 class="text-lg font-black text-kem-dark mb-4 flex items-center gap-2">
                  🛒 Zutaten
                  <span class="text-sm font-normal text-gray-400">
                    ({length(@recipe.ingredients)})
                  </span>
                </h2>
                <ul class="space-y-2">
                  <%= for ingredient <- @recipe.ingredients do %>
                    <li class="flex items-start gap-2 text-sm text-gray-700">
                      <span class="text-kem-green font-bold mt-0.5 flex-shrink-0">✓</span>
                      <span>{ingredient}</span>
                    </li>
                  <% end %>
                </ul>
                <div class="mt-5 pt-4 border-t border-gray-100">
                  <.link
                    navigate={~p"/angebote/live"}
                    class="text-sm text-kem-green font-semibold hover:underline"
                  >
                    🏷️ Zutaten als Angebote suchen →
                  </.link>
                </div>
              </div>
            </div>
          <% end %>

          <%!-- Instructions --%>
          <div class={
            if(@recipe.ingredients && @recipe.ingredients != [],
              do: "md:col-span-2",
              else: "md:col-span-3"
            )
          }>
            <h2 class="text-lg font-black text-kem-dark mb-4">📋 Zubereitung</h2>
            <%= if @recipe.instructions do %>
              <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <div class="prose prose-sm max-w-none text-gray-700 leading-relaxed whitespace-pre-line">
                  {@recipe.instructions}
                </div>
              </div>
            <% else %>
              <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 text-center text-gray-400">
                <p class="text-4xl mb-3">🍳</p>
                <p class="font-medium">Zubereitungsschritte folgen in Kürze.</p>
                <p class="text-sm mt-1">Apu ist noch dabei, alles aufzuschreiben.</p>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>

    <%!-- CTA: Back to recipes --%>
    <div class="bg-white py-10 border-t border-gray-100 text-center">
      <p class="text-gray-500 mb-4">Noch mehr leckere Ideen aus Apu's Küche</p>
      <.link navigate={~p"/rezepte/live"} class="btn-outline-green">
        ← Alle Rezepte ansehen
      </.link>
    </div>
    """
  end
end
