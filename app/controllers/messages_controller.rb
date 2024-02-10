class MessagesController < ApplicationController
  include ActionView::RecordIdentifier

  def create
    @message = current_user.messages.create!(
      body: msg_params[:body],
      room_id: msg_params[:room_id],
      attachments: msg_params[:attachments]
    )
    @message.broadcast_append_to(
      @message.room,
      target: dom_id(@message.room, :messages),
      partial: "messages/message",
      locals: { message: @message, room: @message.room, user: current_user }
    )
  end

  private

  def msg_params
    params.require(:message).permit(:body, :room_id, attachments: [])
  end
end
