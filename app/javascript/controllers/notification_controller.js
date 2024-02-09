// app/javascript/controllers/flash_message_controller.js
import { Controller } from '@hotwired/stimulus'

// Connects to data-controller='notification'
export default class extends Controller {
  connect() {
    console.log('Notification added');
  }

  close() {
    this.element.remove()
  }
}
