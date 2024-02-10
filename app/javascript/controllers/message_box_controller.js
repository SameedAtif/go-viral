import consumer from "channels/consumer";
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
      const roomId = document.getElementById('message-box').dataset.roomId;
      const userId = document.getElementById('message-box').dataset.userId;
      consumer.subscriptions.create({ channel: "RoomsChannel", room: roomId}, {
        received(data) {
          const roomId = document.getElementById('message-box').dataset.roomId;
          if(userId == data.sender_id) {
            $(`#messages-room-${roomId}`).append($.parseHTML( data.sender));
          } else {
            $(`#messages-room-${roomId}`).append($.parseHTML( data.receiver));
          }
          // Called when there's incoming data on the websocket for this channel
          console.log('Received data', data);
          // $("#notifications").prepend(data.html);
        },
      });
    }
    remove() {
      this.element.remove();
    }
}
