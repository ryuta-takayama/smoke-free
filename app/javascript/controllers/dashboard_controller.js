import { Controller } from "@hotwired/stimulus"

// Toggle two panels on the same page: current / history
export default class extends Controller {
  static targets = ["tab", "panel", "timer"]

  connect() {
    this.show("current")
    this.setupTimer()
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

  disconnect() {
    if (this._timerId) clearInterval(this._timerId)
  }

  setupTimer() {
    if (!this.hasTimerTarget) return
    const el = this.timerTarget
    const iso = el.dataset.startAt
    if (!iso) {
      el.textContent = "00:00:00"
      return
    }
    const start = new Date(iso)
    if (isNaN(start)) {
      el.textContent = "00:00:00"
      return
    }

    const update = () => {
      const now = new Date()
      let diffSec = Math.floor((now - start) / 1000)
      if (diffSec < 0) diffSec = 0
      const hours = Math.floor(diffSec / 3600)
      const minutes = Math.floor((diffSec % 3600) / 60)
      const seconds = diffSec % 60
      el.textContent = `${hours}時間${String(minutes).padStart(2, '0')}分${String(seconds).padStart(2, '0')}秒`
    }

    update()
    this._timerId = setInterval(update, 1000)
  }
}
