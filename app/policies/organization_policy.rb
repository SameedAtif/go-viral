class OrganizationPolicy < ApplicationPolicy
  def update?
    # Also add if the user is a reviewer
    (user == record.owner.user && current_role == User::USER_ROLES[:client]) || user.reviewer?
  end
end
