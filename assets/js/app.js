import "phoenix_html"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

// Define your custom hooks here
let Hooks = {};
Hooks.ScrollToBottom = {
  updated() {
    this.el.scrollTop = this.el.scrollHeight; // Automatically scroll to the bottom
  }
};

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks, // Add your hooks to the LiveSocket instance
  params: { _csrf_token: csrfToken },
  longPollFallbackMs: 2500,
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show())
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
