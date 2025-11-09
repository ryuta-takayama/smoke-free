import { Controller } from "@hotwired/stimulus"

// Shows flash messages as native popups (alert)
export default class extends Controller {
  static values = {
    notice: String,
    alert: String
  }

  connect() {
    const notice = this.hasNoticeValue && this.noticeValue && this.noticeValue.trim()
    const alertMsg = this.hasAlertValue && this.alertValue && this.alertValue.trim()

    if (alertMsg) {
      window.alert(alertMsg)
    } else if (notice) {
      window.alert(notice)
    }
  }
}

