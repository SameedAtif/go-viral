class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  after_create_commit { broadcast_append_to room }
  before_create :confirm_participant
  has_many_attached :attachments, dependent: :destroy

  def chat_attachment(index)
    target = attachments[index]
    return unless attachments.attached?
    target
  end

  def confirm_participant
    if self.room.is_private
      is_participant = Participant.find_by(user_id: self.user.id, room_id: self.room.id)
      throw :abort unless is_participant
    end
  end
end
