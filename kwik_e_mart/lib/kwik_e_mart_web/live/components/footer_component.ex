defmodule KwikEMartWeb.FooterComponent do
  use KwikEMartWeb, :html

  def footer(assigns) do
    ~H"""
    <footer class="kem-footer">
      <div class="kem-footer-inner">
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8 mb-8">
          <div>
            <div class="text-white font-black text-2xl tracking-tight mb-4">
              <span class="text-kem-yellow">K</span>wik-E-Mart
            </div>
            <p class="text-gray-400 text-sm">Thank you, come again!</p>
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
            <h4 class="text-white font-semibold mb-3">Über Kwik-E-Mart</h4>
            <ul class="space-y-2 text-sm text-gray-400">
              <li>Unternehmen</li>
              <li>Karriere</li>
              <li>Presse</li>
            </ul>
          </div>
          <div>
            <h4 class="text-white font-semibold mb-3">Service</h4>
            <ul class="space-y-2 text-sm text-gray-400">
              <li>Kundenservice</li>
              <li>Datenschutz</li>
              <li>Impressum</li>
            </ul>
          </div>
        </div>
        <div class="border-t border-gray-700 pt-6 flex flex-col sm:flex-row items-center justify-between gap-4">
          <p class="text-gray-500 text-xs">© 2026 Kwik-E-Mart, Springfield</p>
          <p class="text-gray-600 text-xs">Fan-Projekt – inspiriert von edeka.de · Powered by Phoenix + Beacon CMS</p>
        </div>
      </div>
    </footer>
    """
  end
end
