import consumer from "channels/consumer";

consumer.subscriptions.create("NotificationsChannel", {
  initialized() {},

  connected() {
    // Called when the subscription is ready for use on the server
    // console.log("Notifications channel connected");
    this.install();
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    // console.log("Disconnected");
    this.uninstall();
  },

  rejected() {
    // console.log("Rejected");
    this.uninstall();
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    // console.log('Received data', data);
    // $("#notifications").prepend(data.html);
  },

  uninstall() {
    // console.log("Uninstall");
  },

  install() {
    // console.log("Install");
  }
});
