class GigClientPolicy < ApplicationPolicy
  def update?
    (record.gig.influencer == user.influencer && current_role == User::USER_ROLES[:influencer]) ||
    (record.client == user.client && current_role == User::USER_ROLES[:client])
  end
end
