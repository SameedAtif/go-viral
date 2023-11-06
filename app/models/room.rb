class Room < ApplicationRecord
  has_many :messages
  has_many :participants, dependent: :destroy

  validates_uniqueness_of :name
  scope :public_rooms, -> { where(is_private: false) }
  after_create_commit { broadcast_if_public }

  def broadcast_if_public
    broadcast_append_to "rooms" unless self.is_private
  end

  def participant?(room, user)
    room.participants.where(user: user).any?
  end

  def get_name(user)
    "private_#{user.id}"
  end

  def add_user(user)
    participants.find_or_create_by!(user_id: user.id)
  end

  def remove_user(user)
    participants&.find_by(user_id: user.id).destroy
  end
end
