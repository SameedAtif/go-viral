class OrganizationSystemPackagePolicy < ApplicationPolicy
  def create?
    user_org = user.client.organization
    base_case = user_org == record.organization && current_role == User::USER_ROLES[:client]
    resolved_request = user_org.organization_package_downgrade_requests.where(
      current_package: user_org.current_package, requested_package: record.system_package,
      status: OrganizationPackageDowngradeRequest::STATUS_TYPES_MAP[:approved]
    ).present?
    if user_org.current_package.present?
      (record.system_package.total_price > user_org.current_package.total_price || resolved_request) && base_case
    else
      base_case
    end
  end
end
