import { Controller } from "@hotwired/stimulus"

// Flash presenter. styleValue: "alert" | "toast"
export default class extends Controller {
  static values = {
    notice: String,
    alert: String,
    style: { type: String, default: "alert" }
  }

  connect() {
    const notice = this.hasNoticeValue && this.noticeValue && this.noticeValue.trim()
    const alertMsg = this.hasAlertValue && this.alertValue && this.alertValue.trim()
    const message = alertMsg || notice
    if (!message) return

    if (this.styleValue === "toast") {
      this.showToast(message, !!alertMsg)
    } else {
      window.alert(message)
    }
  }

  showToast(message, isAlert = false) {
    let container = document.querySelector(".toast-container")
    if (!container) {
      container = document.createElement("div")
      container.className = "toast-container"
      document.body.appendChild(container)
    }

    const toast = document.createElement("div")
    toast.className = `toast${isAlert ? " danger" : ""}`
    toast.textContent = message
    toast.addEventListener("click", () => this.dismiss(toast))
    container.appendChild(toast)

    // animate in
    requestAnimationFrame(() => toast.classList.add("show"))

    // auto hide after 3s
    setTimeout(() => this.dismiss(toast), 3000)
  }

  dismiss(toast) {
    if (!toast) return
    toast.classList.remove("show")
    toast.addEventListener("transitionend", () => {
      toast.remove()
      const container = document.querySelector(".toast-container")
      if (container && container.children.length === 0) container.remove()
    }, { once: true })
  }
}
