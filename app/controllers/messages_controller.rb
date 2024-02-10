class MessagesController < ApplicationController
  include ActionView::RecordIdentifier

  def create
    @message = current_user.messages.create!(
      body: msg_params[:body],
      room_id: msg_params[:room_id],
      attachments: msg_params[:attachments]
    )
    current_participant = @message.room.participants.find_by(user: current_user)
    other_participants = @message.room.participants.where.not(id: current_participant.id)
    @message.broadcast_append_to(
      @message.room,
      target: dom_id(@message.room, :messages),
      partial: "messages/message",
      locals: { message: @message, room: @message.room, user: current_user }
    )
    @message.broadcast_prepend_to(
      "notifications_channel:#{other_participants.first.user.id}",
      target: "notifications",
      partial: 'shared/notifications/message_notification',
      locals: { message: @message }
    )
  end

  private

  def msg_params
    params.require(:message).permit(:body, :room_id, attachments: [])
  end
end
