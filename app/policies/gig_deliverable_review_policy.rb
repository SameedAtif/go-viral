class GigDeliverableReviewPolicy < ApplicationPolicy
  def update?
    user == record.client.user && current_role == User::USER_ROLES[:client]
  end

  def create?
    user == record.client.user && current_role == User::USER_ROLES[:client]
  end

  def permitted_attributes
    record_attributes = [
      :id, :remarks, :rating, :status
    ]
    if user == record.gig_client.client.user && current_role == User::USER_ROLES[:client]
      record_attributes
    end
  end
end
