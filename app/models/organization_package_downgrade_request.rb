
class OrganizationPackageDowngradeRequest < ApplicationRecord
  belongs_to :current_package, class_name: 'SystemPackage', foreign_key: 'current_package_id'
  belongs_to :requested_package, class_name: 'SystemPackage', foreign_key: 'requested_package_id'
  belongs_to :reviewer, optional: true
  belongs_to :organization

  STATUS_TYPES_MAP = {
    pending_review: 'pending_review',
    approved: 'approved',
    rejected: 'rejected'
  }.freeze
  STATUS_TYPES = STATUS_TYPES_MAP.values

  validate :application_locked
  validates :status, inclusion: { in: STATUS_TYPES }
  validates_presence_of :reason, :status
  validates_length_of :reason, minimum: 3

  after_create_commit :notify_reviewer
  after_update_commit :notify_client, :mark_as_resolved!, if: -> { saved_change_to_attribute?('status') }

  private

  def application_locked
    return unless resolved

    errors.add(:base, "This request is now locked")
  end

  def notify_client
    return if status == STATUS_TYPES_MAP[:pending_review]

    Notification.create!(
      resource_id: organization.id,
      resource_type: organization.class.name,
      user_id: organization.owner.user_id,
      user_type: User::USER_ROLES[:client],
      notification_type: Notification::NOTIFICATION_TYPES_MAP[:client_package_downgrade_update]
    )
  end

  def notify_reviewer
    Reviewer.all.pluck(:user_id).each do |user_id|
      Notification.create!(
        resource_id: organization.id,
        resource_type: organization.class.name,
        user_id: user_id,
        user_type: User::USER_ROLES[:reviewer],
        notification_type: Notification::NOTIFICATION_TYPES_MAP[:client_package_downgrade_request]
      )
    end
  end

  def mark_as_resolved!
    return if status == STATUS_TYPES_MAP[:pending_review]

    update_column(:resolved, true)
  end
end
