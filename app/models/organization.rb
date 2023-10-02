class Organization < ApplicationRecord
  has_many :projects
  has_many :organization_reviews
  has_many :organization_details, dependent: :destroy
  has_many :clients, through: :organization_details
  has_many :organization_system_packages
  has_many :organization_package_downgrade_requests

  validates_presence_of :name, :address_1, :address_2, :city, :country, :phone_number

  after_create_commit :notify_reviewer
  after_update_commit :notify_client, if: -> { saved_change_to_attribute?('verified') }

  def owner
    organization_details.find_by(client_role: OrganizationDetail::CLIENT_ROLES_MAP[:owner]).client
  end

  def current_org_sys_package
    organization_system_packages.last
  end

  def current_package
    current_org_sys_package&.system_package
  end

  private

  def notify_reviewer
    Reviewer.all.pluck(:user_id).each do |user_id|
      Notification.create!(
        resource_id: id,
        resource_type:self.class.name,
        user_id: user_id,
        user_type: User::USER_ROLES[:reviewer],
        notification_type: Notification::NOTIFICATION_TYPES_MAP[:reviewer_organization_created]
      )
    end
  end

  def notify_client
    return unless verified

    Notification.create!(
      resource_id: id,
      resource_type:self.class.name,
      user_id: owner.user_id,
      user_type: User::USER_ROLES[:client],
      notification_type: Notification::NOTIFICATION_TYPES_MAP[:client_organization_verified]
    )
  end
end
