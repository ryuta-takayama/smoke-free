import { Controller } from "@hotwired/stimulus"

// Controls the 3-step registration wizard
export default class extends Controller {
  static targets = [
    "step",
    "indicator",
    "passwordField",
    "passwordConfirmationField",
    "form"
  ]

  connect() {
    this.current = 1
    this.total = this.stepTargets.length
    this.update()
    // Intercept Enter key to move forward before final step
    this._onKeydown = (e) => {
      if (e.key === 'Enter') {
        const isFinal = this.current === this.total
        if (!isFinal) {
          e.preventDefault()
          this.next()
        }
      }
    }
    this.element.addEventListener('keydown', this._onKeydown)
  }

  disconnect() {
    this.element.removeEventListener('keydown', this._onKeydown)
  }

  next() {
    if (this.current < this.total) {
      this.current++
      this.update()
    }
  }

  back() {
    if (this.current > 1) {
      this.current--
      this.update()
    }
  }

  // finalize() removed: submit is handled natively by the form

  togglePassword() {
    this._toggleField(this.passwordFieldTarget)
  }

  togglePasswordConfirmation() {
    this._toggleField(this.passwordConfirmationFieldTarget)
  }

  update() {
    this.stepTargets.forEach((el) => {
      const step = Number(el.dataset.step)
      const active = step === this.current
      el.toggleAttribute('hidden', !active)
    })

    this.indicatorTargets.forEach((el) => {
      const step = Number(el.dataset.step)
      el.classList.remove('is-active', 'is-done')
      if (step < this.current) el.classList.add('is-done')
      if (step === this.current) el.classList.add('is-active')
    })
  }

  _toggleField(field) {
    if (!field) return
    const type = field.getAttribute('type') === 'password' ? 'text' : 'password'
    field.setAttribute('type', type)
  }
}
