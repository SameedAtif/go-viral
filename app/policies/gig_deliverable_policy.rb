class GigDeliverablePolicy < ApplicationPolicy
  def update?
    # Also add if the user is a reviewer
    user == record.gig_client.gig.influencer.user && current_role == User::USER_ROLES[:influencer] && user.influencer.reviewed
  end

  def create?
    user == record.gig_client.gig.influencer.user && current_role == User::USER_ROLES[:influencer] && user.influencer.reviewed
  end

  def permitted_attributes
    record_attributes = [
      :id, :title, :description
    ]
    if (user.admin? && current_role == User::USER_ROLES[:admin]) || (
        user == record.gig_client.gig.influencer.user && current_role == User::USER_ROLES[:influencer] &&
        user.influencer.reviewed
      )
      record_attributes
    end
  end
end
