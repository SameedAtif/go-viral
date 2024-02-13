class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many_attached :attachments, dependent: :destroy

  validate :confirm_participant

  def chat_attachment(index)
    target = attachments[index]
    return unless attachments.attached?
    target
  end

  def confirm_participant
    is_participant = Participant.find_by(user_id: self.user.id, room_id: self.room.id)
    errors.add(:base, "Participant is required") unless is_participant
  end
end
