class ProjectInfluencer < ApplicationRecord
  belongs_to :project
  belongs_to :influencer

  after_create_commit :notify_influencer

  private

  def notify_influencer
    Notification.create!(
      resource_id: project_id,
      resource_type: project.class.name,
      user_id: influencer.user_id,
      user_type: User::USER_ROLES[:influencer],
      notification_type: Notification::NOTIFICATION_TYPES_MAP[:client_creator_applied_to_project]
    )
  end
end
