class OrganizationPackageDowngradeRequestPolicy < ApplicationPolicy
  def create?
    user_org = user.client.organization
    user_org == record.organization && current_role == User::USER_ROLES[:client]
  end

  def update?
    user.reviewer? && current_role == User::USER_ROLES[:reviewer]
  end
end
