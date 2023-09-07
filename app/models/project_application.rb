class ProjectApplication < ApplicationRecord
  belongs_to :project
  belongs_to :influencer

  STATUS_TYPES_MAP = {
    draft: 'draft',
    ready_for_review: 'ready_for_review',
    approved: 'approved',
    rejected: 'rejected'
  }.freeze
  STATUS_TYPES = STATUS_TYPES_MAP.values

  validate :application_locked
  validates :status, inclusion: { in: STATUS_TYPES }
  validates_presence_of :title, :description, :status
  validates_length_of :title, :description, minimum: 3

  after_update_commit :create_project_influencer, :remove_project_influencer, :notify_client, if: -> { saved_change_to_attribute?('status') }

  private

  def application_locked
    return unless [STATUS_TYPES_MAP[:approved], STATUS_TYPES_MAP[:rejected]].include?(status_was) && DateTime.current < project.start_time

    errors.add(:base, "This campaign application is now locked")
  end

  def create_project_influencer
    project.project_influencers.find_or_create_by!(influencer: influencer) if status == STATUS_TYPES_MAP[:approved]
  end

  def remove_project_influencer
    return unless status == STATUS_TYPES_MAP[:rejected]

    project.project_influencers.find_by(influencer: influencer)&.destroy!
    Notification.create!(
      resource_id: project_id,
      resource_type: project.class.name,
      user_id: influencer.user_id,
      user_type: User::USER_ROLES[:influencer],
      notification_type: Notification::NOTIFICATION_TYPES_MAP[:influencer_rejected_for_project]
    )
  end

  def notify_client
    Notification.create!(
      resource_id: project_id,
      resource_type: project.class.name,
      user_id: influencer.user_id,
      user_type: User::USER_ROLES[:influencer],
      notification_type: Notification::NOTIFICATION_TYPES_MAP[:influencer_rejected_for_project]
    )
  end
end
