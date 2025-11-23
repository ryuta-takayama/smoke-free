import { Controller } from "@hotwired/stimulus"

// Updates goal simulation numbers on the form without page reload
export default class extends Controller {
  static targets = ["amount", "startDate", "days", "progress"]
  static values = {
    dailySaving: Number,
    savedMoney: Number
  }

  connect() {
    this.defaultDaysText = this.daysTarget.textContent.trim() || "— 日"
    this.defaultProgressText = this.progressTarget.textContent.trim() || "— %"
    this.update()
  }

  update() {
    const dailySaving = this.dailySavingValue || 0
    const targetAmount = this.parseNumber(this.amountTarget.value)
    const startDate = this.startDateTarget.value

    if (!dailySaving || !targetAmount || targetAmount <= 0 || !startDate) {
      this.daysTarget.textContent = this.defaultDaysText
      this.progressTarget.textContent = this.defaultProgressText
      return
    }

    const start = this.parseDate(startDate)
    if (!start) {
      this.daysTarget.textContent = this.defaultDaysText
      this.progressTarget.textContent = this.defaultProgressText
      return
    }

    const elapsedDays = this.elapsedDaysSince(start)
    const saved = elapsedDays * dailySaving

    // Remaining days until goal (cannot go below 0)
    const remaining = Math.max(0, targetAmount - saved)
    const days = remaining === 0 ? 0 : Math.ceil(remaining / dailySaving)
    this.daysTarget.textContent = `${days} 日`

    let progress = (saved / targetAmount) * 100
    progress = Math.min(progress, 999)
    // Keep one decimal until 100%, then show whole numbers
    const formatted = progress >= 100 ? Math.round(progress).toString() : progress.toFixed(1)
    this.progressTarget.textContent = `${formatted} %`
  }

  parseNumber(value) {
    if (!value) return null
    const numeric = parseInt(String(value).replace(/,/g, ""), 10)
    return Number.isFinite(numeric) ? numeric : null
  }

  parseDate(value) {
    const d = new Date(value)
    return Number.isNaN(d.getTime()) ? null : d
  }

  elapsedDaysSince(date) {
    const today = new Date()
    const start = new Date(date)
    // Normalize to local midnight to avoid partial days
    start.setHours(0, 0, 0, 0)
    today.setHours(0, 0, 0, 0)
    const diffMs = today - start
    return Math.max(0, Math.floor(diffMs / 86400000)) // 1000*60*60*24
  }
}
