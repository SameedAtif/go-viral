class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_channel:#{current_user.id}"
  end

  def unsubscribed
    stop_stream_from "notifications_channel:#{current_user.id}"
  end

  def receive(data)
    ActionCable.server.broadcast("notifications_channel:#{current_user.id}", data)
  end
end
