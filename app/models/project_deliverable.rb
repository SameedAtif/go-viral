class ProjectDeliverable < ApplicationRecord
  belongs_to :project_milestone
  belongs_to :influencer

  has_one :project_deliverable_reviews

  validates_presence_of :title, :description
  validates_length_of :title, :description, minimum: 3

  after_save_commit :notify_client, on: %i[create update]

  private

  def notify_client
    Notification.create!(
      resource_id: project_milestone.project.id,
      resource_type: project_milestone.project.class.name,
      user_id: project_milestone.project.organization.owner.user_id,
      user_type: User::USER_ROLES[:client],
      notification_type: Notification::NOTIFICATION_TYPES_MAP[:client_influencer_delivered_milestone]
    )
  end
end
