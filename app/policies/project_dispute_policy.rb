class ProjectDisputePolicy < ApplicationPolicy
  def create?
    (user.influencer? && current_role == User::USER_ROLES[:influencer] &&
      record.project.project_influencers.where(influencer: user.influencer).any?) ||
    (user.client? && current_role == User::USER_ROLES[:client] &&
      record.project.organization.organization_details.where(client: user.client).any?)
  end

  def update?
    (record.send("#{record.created_by}").user == user &&
      current_role == User::USER_ROLES[record.created_by.to_sym]) ||
    (user.reviewer? && current_role == User::USER_ROLES[:reviewer])
  end

  def permitted_attributes
    if (user.reviewer? && current_role == User::USER_ROLES[:reviewer])
      [:status, :resolved_in_favor]
    else
      [:detail]
    end
  end
end
