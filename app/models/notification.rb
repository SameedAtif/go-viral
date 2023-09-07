class Notification < ApplicationRecord
  belongs_to :source, polymorphic: true, optional: true
  belongs_to :user

  NOTIFICATION_TYPES_MAP = {
    new_project_request: 'new_project_request',
    influencer_approved_for_project: 'influencer_approved_for_project',
    influencer_rejected_for_project: 'influencer_rejected_for_project',
    client_influencer_applied_to_project: 'client_influencer_applied_to_project'
  }
  NOTIFICATION_TYPES = NOTIFICATION_TYPES_MAP.values

  validates :notification_type, inclusion: { in: NOTIFICATION_TYPES }
  validates :user_type, inclusion: { in: User::USER_ROLES_VALUES }
  validates :user_type, :notification_type, :resource_type, :resource_id, :user_id, presence: true
end

