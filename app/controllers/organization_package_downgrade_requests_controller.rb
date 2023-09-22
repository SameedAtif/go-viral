class OrganizationPackageDowngradeRequestsController < ApplicationController
  before_action :set_resource, only: :update
  before_action :set_organization, only: :create

  def create
    resource = @organization.organization_package_downgrade_request.new(creation_params)
    resource.current_package = @organization.current_package
    authorize resource
    resource.save!
  end

  def update
    authorize @resource
    @resource.update!(permitted_params)
  end

  private

  def set_resource
    @resource = OrganizationPackageDowngradeRequest.find(params[:organization_package_downgrade_request])
  end

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def creation_params
    params.require(:organization_package_downgrade_request).permit(
      :requested_package_id, :reason
    )
  end

  def permitted_params
    params.require(:organization_package_downgrade_request).permit(
      :status, :refundable_amount, :fee
    )
  end
end
