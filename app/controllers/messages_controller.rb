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
    ActionCable.server.broadcast("rooms_channel:#{@message.room.id}", broadcast_payload)
    @message.broadcast_append_later_to(
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

  def broadcast_payload
    {
      sender: ApplicationController.render(
        target: dom_id(@message.room, :messages),
        partial: 'messages/sent_message',
        locals: { message: @message, sender: true }
      ),
      receiver: ApplicationController.render(
        target: dom_id(@message.room, :messages),
        partial: 'messages/received_message',
        locals: { message: @message, sender: true }
      ),
      sender_id: @message.user.id
    }
  end
end
