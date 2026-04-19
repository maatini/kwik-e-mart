defmodule KwikEMartWeb.FooterComponent do
  use KwikEMartWeb, :html

  def footer(assigns) do
    ~H"""
    <footer class="edeka-footer">
      <div class="edeka-footer-inner">
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8 mb-8">
          <div>
            <div class="text-white font-black text-2xl tracking-tight mb-4">
              <span class="text-edeka-yellow">E</span>DEKA
            </div>
            <p class="text-gray-400 text-sm">Wir lieben Lebensmittel.</p>
          </div>
          <div>
            <h4 class="text-white font-semibold mb-3">Einkaufen</h4>
            <ul class="space-y-2 text-sm text-gray-400">
              <li><.link navigate="/angebote/live" class="hover:text-white transition-colors">Angebote</.link></li>
              <li><.link navigate="/rezepte/live" class="hover:text-white transition-colors">Rezepte</.link></li>
              <li><.link navigate="/markt-waehlen" class="hover:text-white transition-colors">Markt finden</.link></li>
            </ul>
          </div>
          <div>
            <h4 class="text-white font-semibold mb-3">Über EDEKA</h4>
            <ul class="space-y-2 text-sm text-gray-400">
              <li><span class="hover:text-white transition-colors cursor-pointer">Unternehmen</span></li>
              <li><span class="hover:text-white transition-colors cursor-pointer">Karriere</span></li>
              <li><span class="hover:text-white transition-colors cursor-pointer">Presse</span></li>
            </ul>
          </div>
          <div>
            <h4 class="text-white font-semibold mb-3">Service</h4>
            <ul class="space-y-2 text-sm text-gray-400">
              <li><span class="hover:text-white transition-colors cursor-pointer">Kundenservice</span></li>
              <li><span class="hover:text-white transition-colors cursor-pointer">Datenschutz</span></li>
              <li><span class="hover:text-white transition-colors cursor-pointer">Impressum</span></li>
            </ul>
          </div>
        </div>
        <div class="border-t border-gray-700 pt-6 flex flex-col sm:flex-row items-center justify-between gap-4">
          <p class="text-gray-500 text-xs">© 2026 EDEKA Zentrale AG & Co. KG</p>
          <p class="text-gray-600 text-xs">Powered by Phoenix + Beacon CMS</p>
        </div>
      </div>
    </footer>
    """
  end
end
