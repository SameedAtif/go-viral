class ProjectDeliverableReview < ApplicationRecord
  belongs_to :client
  belongs_to :project
  belongs_to :project_deliverable

  STATUS_TYPES_MAP = {
    ready_for_review: 'ready_for_review',
    approved: 'approved',
    rejected: 'rejected'
  }.freeze
  STATUS_TYPES = STATUS_TYPES_MAP.values

  validates :status, inclusion: { in: STATUS_TYPES }
  validates_length_of :remarks, minimum: 3
  validates :achieved_reach, :achieved_conversion, numericality: { only_integer: true }
  validate :deliverable_locked

  after_save_commit :notify_creator, on: %i[create update], if: -> { saved_change_to_attribute?('status') }

  private

  def deliverable_locked
    return if DateTime.current < project_deliverable.project_milestone.end_time

    errors.add(:base, "This campaign deliverable is now locked")
  end

  def notify_creator
    return unless [STATUS_TYPES_MAP[:approved], STATUS_TYPES_MAP[:rejected]].include?(status)

    Notification.create!(
      resource_id: project.id,
      resource_type: project.class.name,
      user_id: project_deliverable.influencer.user.id,
      user_type: User::USER_ROLES[:influencer],
      notification_type: creator_notification_type
    )
  end

  def creator_notification_type
    if status == STATUS_TYPES_MAP[:approved]
      Notification::NOTIFICATION_TYPES_MAP[:creator_project_deliverable_approved]
    elsif status == STATUS_TYPES_MAP[:rejected]
      Notification::NOTIFICATION_TYPES_MAP[:creator_project_deliverable_rejected]
    end
  end
end
