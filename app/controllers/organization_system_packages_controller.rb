class OrganizationSystemPackagesController < ApplicationController
  before_action :load_organization, only: :create

  # What should happen when some org already has a package?
  # User should not be able to downgrade to a smaller package if he has bought an expensive package
  # User can only upgrade to a more expensive package.
  # Incase of downgrade, request will be accepted when timespan is complete or reviewer approves
  # Same for refund, Incase of refund it will be downgraded to base package.
  # Incase of upgrade, it would be instant
  # How would changing a package look
  # Incase of downgrade:
  # 1. reviewer approves
  # 2. client is notified "Your package will be refunded after n days of purchasing approved package".
  # 3. when client buys the approved package
  # 4. schedule refund.
  def create
    @system_package = SystemPackage.find(params[:organization_system_package][:system_package_id])
    # res = create_purchase
    # if res.success?
    OrganizationSystemPackage.transaction do
      @org_sys_pkg = OrganizationSystemPackage.new(organization: @organization, system_package: @system_package)
      authorize @org_sys_pkg
      @org_sys_pkg.payment_plan = @system_package.payment_plan
      @org_sys_pkg.start_time = DateTime.current
      if @org_sys_pkg.payment_plan.present?
        @org_sys_pkg.end_time = 1.send("#{@org_sys_pkg.payment_plan}").from_now
      else
        @org_sys_pkg.end_time = 100.years.from_now
      end
      resolved_request = @organization.organization_package_downgrade_requests.where(
        resolved: true, current_package: @organization.current_package, requested_package: @org_sys_pkg.system_package,
        status: OrganizationPackageDowngradeRequest::STATUS_TYPES_MAP[:approved]
      )
      if resolved_request.present? && @organization.current_package.present?
        # TODO: Move this to perform_at(5.days.from_now)
        @organization.current_package.refund!(
          amount: resolved_request.refundable_amount, fee: resolved_request.fee, reviewer_id: resolved_request.reviewer.id
        )
      end
      @org_sys_pkg.save!
      @system_package.system_package_resources.each do |resource|
        OrganizationSystemPackageResource.create!(
          organization_system_package: @org_sys_pkg,
          system_package_resource: resource
        )
      end
      @org_sys_pkg_trans = OrganizationSystemPackageTransaction.create!(
        organization_system_package_transaction_payload("ABC", "credit", @system_package)
      )
      @org_sys_pkg.organization_system_package_resources.each do |org_sys_pkg_r|
        OrganizationSystemPackageResourceTransaction.create!(
          organization_system_package_resource_transaction_payload(org_sys_pkg_r)
        )
      end
    end
    @organization.update!(payment_plan: @system_package.package_name)
  end

  def destroy
    # TODO: This functionality should not be exposed. End user can only 'request a refund'. Only reviewer can refund.
    @org_sys_pkg = OrganizationSystemPackage.find(params[:id])
    @org_sys_pkg.refund!
  end

  private

  def load_organization
    @organization = Organization.find(params[:organization_id])
  end

  def permitted_params
    params.require(:organization_system_package).permit(:system_package_id)
  end

  def organization_system_package_transaction_payload(transaction_token, transaction_type, system_package)
    {
      organization_system_package: @org_sys_pkg,
      client: current_user.client,
      transaction_type: transaction_type,
      transaction_token: transaction_token,
      package_name: system_package.package_name,
      package_description: system_package.package_description,
      gross_price: system_package.gross_price, fee: system_package.fee,
      discount: system_package.discount, discount_expires_at: system_package.discount_expires_at,
      start_time: @org_sys_pkg.start_time,
      end_time: @org_sys_pkg.end_time
    }
  end

  def organization_system_package_resource_transaction_payload(org_sys_pkg_r)
    {
      organization_system_package_transaction: @org_sys_pkg_trans,
      organization_system_package_resource: org_sys_pkg_r,
      resource_name: org_sys_pkg_r.system_package_resource.resource_name,
      resource_value: org_sys_pkg_r.system_package_resource.resource_value,
      gross_price: org_sys_pkg_r.system_package_resource.gross_price,
      fee: org_sys_pkg_r.system_package_resource.fee,
      discount: org_sys_pkg_r.system_package_resource.discount,
      discount_expires_at: org_sys_pkg_r.system_package_resource.discount_expires_at
    }
  end
end
