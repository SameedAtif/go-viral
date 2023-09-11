class ProjectDeliverableReviewPolicy < ApplicationPolicy
  def update?
    user == record.client.user && current_role == User::USER_ROLES[:client]
  end

  def create?
    user == record.client.user && current_role == User::USER_ROLES[:client]
  end

  def permitted_attributes
    record_attributes = [
      :id, :achieved_reach, :achieved_conversion, :remarks,
      :rating, :status
    ]
    if user == record.project.organization.owner.user && current_role == User::USER_ROLES[:client]
      record_attributes
    end
  end
end
