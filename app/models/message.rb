class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many_attached :attachments, dependent: :destroy

  after_create_commit { broadcast_append_to room }
  before_create :confirm_participant

  def chat_attachment(index)
    target = attachments[index]
    return unless attachments.attached?
    target
  end

  def confirm_participant
    if self.room.is_private
      is_participant = Participant.find_by(user_id: self.user.id, room_id: self.room.id)
      errors.add(:base, "Participant is required") unless is_participant
    end
  end
end
