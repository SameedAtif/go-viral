// app/javascript/controllers/flash_message_controller.js
import { Controller } from '@hotwired/stimulus'

// Connects to data-controller='flash-message'
export default class extends Controller {
  connect() {

  }

  close() {
    this.element.remove()
  }
}
