class OrganizationSystemPackagesController < ApplicationController
  before_action :load_organization, only: :create

  def create
    @system_package = SystemPackage.find(params[:organization_system_package][:system_package_id])
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
    organization.update(payment_plan: @system_package.package_name)
  end

  def destroy
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
