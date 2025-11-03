import { Controller } from "@hotwired/stimulus"

// Simple password visibility toggle for single input
export default class extends Controller {
  static targets = ["input"]

  toggle() {
    const field = this.inputTarget
    const nextType = field.getAttribute('type') === 'password' ? 'text' : 'password'
    field.setAttribute('type', nextType)
  }
}

