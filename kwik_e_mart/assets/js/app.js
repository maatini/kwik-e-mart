// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

// Persist selected market in a 1-year cookie so the server-side
// FetchMarket plug can restore it into the session on subsequent requests.
window.addEventListener("phx:market_selected", (e) => {
  document.cookie = `kem_market_id=${e.detail.market_id}; path=/; max-age=31536000; SameSite=Lax`
})

const Hooks = {}

// Reads browser geolocation and fires the "use_location" LiveView event.
Hooks.Geolocation = {
  mounted() {
    this.el.addEventListener("click", () => {
      navigator.geolocation.getCurrentPosition(
        (pos) => this.pushEvent("use_location", {lat: pos.coords.latitude, lng: pos.coords.longitude}),
        () => this.pushEvent("use_location", {error: "denied"})
      )
    })
  }
}

// Leaflet map for MarketFinder. Listens for "update_map" events from the server
// containing a list of {name, street, city, lat, lng} market objects.
Hooks.LeafletMap = {
  mounted() {
    this.map = L.map(this.el, {zoomControl: true}).setView([39.78, -86.16], 10)
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "&copy; OpenStreetMap contributors"
    }).addTo(this.map)
    this.markers = []

    this.handleEvent("update_map", ({markets}) => {
      this.markers.forEach(m => m.remove())
      this.markers = []
      if (!markets || markets.length === 0) return
      const bounds = []
      markets.forEach(({name, street, city, lat, lng}) => {
        if (!lat || !lng) return
        const marker = L.marker([lat, lng])
          .addTo(this.map)
          .bindPopup(`<strong>${name}</strong><br/>${street}, ${city}`)
        this.markers.push(marker)
        bounds.push([lat, lng])
      })
      if (bounds.length > 0) this.map.fitBounds(bounds, {padding: [40, 40]})
    })
  },
  destroyed() {
    if (this.map) this.map.remove()
  }
}

let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

