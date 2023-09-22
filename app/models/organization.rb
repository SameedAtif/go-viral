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
  after_update_commit :create_org_package, if: -> { saved_change_to_attribute?('payment_plan') }

  def owner
    organization_details.find_by(client_role: OrganizationDetail::CLIENT_ROLES_MAP[:owner]).client
  end

  def current_package
    organization_system_packages.last
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

  def create_org_package
    return unless payment_plan == 'basic'
    @system_package = SystemPackage.find(package_name: 'basic')
    # res = create_purchase
    # if res.success?
    OrganizationSystemPackage.transaction do
      @org_sys_pkg = OrganizationSystemPackage.create!(organization: @organization, system_package: @system_package)
      @org_sys_pkg_trans = OrganizationSystemPackageTransaction.create!(
        organization_system_package_transaction_payload("ABC", "credit", @system_package)
      )
      @org_sys_pkg.organization_system_package_resources.each do |org_sys_pkg_r|
        OrganizationSystemPackageResourceTransaction.create!(
          organization_system_package_resource_transaction_payload(org_sys_pkg_r)
        )
      end
    end
  end

  def organization_system_package_transaction_payload(transaction_token, transaction_type, system_package)
    {
      organization_system_package: @org_sys_pkg,
      user: current_user,
      client: current_user.client,
      transaction_type: transaction_type,
      transaction_token: transaction_token,
      package_name: system_package.package_name,
      package_description: system_package.package_description,
      gross_price: system_package.gross_price, fee: system_package.fee,
      discount: system_package.discount, discount_expires_at: system_package.discount_expires_at,
      start_time: system_package.start_time,
      end_time: system_package.end_time
    }
  end

  def organization_system_package_resource_transaction_payload(org_sys_pkg_r)
    {
      organization_system_package_transaction: @org_sys_pkg_trans,
      organization_system_package_resource: org_sys_pkg_r,
      resource_name: org_sys_pkg_r.resource_name,
      property_name: org_sys_pkr_r.property_name,
      property_type: org_sys_pkr_r.property_type,
      operation: org_sys_pkr_r.operation,
      operation_value: org_sys_pkr_r.operation_value,
      gross_price: org_sys_pkr_r.gross_price,
      fee: org_sys_pkr_r.fee,
      discount: org_sys_pkr_r.discount,
      discount_expires_at: org_sys_pkr_r.discount_expires_at
    }
  end
end
