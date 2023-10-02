class SystemProjectTransactionPolicy < ApplicationPolicy
  def create?
    user.client? && current_role == User::USER_ROLES[:client]
  end
end
