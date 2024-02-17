class RoomsChannel < ApplicationCable::Channel
  def subscribed
    @room = current_user.rooms.find(params[:room])
    stream_from "rooms_channel:#{params[:room]}"
  end
end
