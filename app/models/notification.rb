class Notification < ApplicationRecord
  belongs_to :source, polymorphic: true, optional: true
  belongs_to :user

  NOTIFICATION_TYPES_MAP = {}
  NOTIFICATION_TYPES = NOTIFICATION_TYPES_MAP.values

  validates :type, inclusion: { in: NOTIFICATION_TYPES }
  validates :user_type, inclusion: { in: User::USER_ROLES_VALUES }
  validates :user_type, :type, :source_type, :source_id, :user_id, presence: true
end

