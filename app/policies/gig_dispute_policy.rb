class GigDisputePolicy < ApplicationPolicy
  def create?
    (user.influencer? && current_role == User::USER_ROLES[:influencer] &&
      record.gig_client.gig.influencer == user.influencer) ||
    (user.client? && current_role == User::USER_ROLES[:client] &&
      record.gig_client.client == user.client)
  end

  def update?
    is_reviewer = (user.reviewer? && current_role == User::USER_ROLES[:reviewer])
    creator = user.send("#{record.created_by}") == record.gig_client.client || user.send("#{record.created_by}") == record.gig_client.gig.influencer
    is_creator = current_role == User::USER_ROLES[record.created_by.to_sym] && creator
    is_reviewer || is_creator
  end

  def permitted_attributes
    if (user.reviewer? && current_role == User::USER_ROLES[:reviewer])
      [:status, :resolved_in_favor]
    else
      [:detail]
    end
  end
end
