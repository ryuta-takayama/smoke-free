import { Controller } from "@hotwired/stimulus"

// Toggle two panels on the same page: current / history
export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    this.show("current")
  }

  showCurrent() { this.show("current") }
  showHistory() { this.show("history") }

  show(which) {
    this.tabTargets.forEach((t) => {
      const active = t.dataset.tab === which
      t.classList.toggle("is-active", active)
    })
    this.panelTargets.forEach((p) => {
      const active = p.dataset.panel === which
      p.classList.toggle("is-hidden", !active)
    })
  }
}

