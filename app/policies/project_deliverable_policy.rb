class ProjectDeliverablePolicy < ApplicationPolicy
  def update?
    # Also add if the user is a reviewer
    user == record.influencer.user && current_role == User::USER_ROLES[:influencer] && user.influencer.reviewed
  end

  def create?
    user == record.influencer.user && current_role == User::USER_ROLES[:influencer] && user.influencer.reviewed &&
    record.project_milestone.project.project_influencers.find_by(influencer_id: user.influencer.id).present?
  end

  def permitted_attributes
    record_attributes = [
      :id, :title, :description
    ]
    if (user.admin? && current_role == User::USER_ROLES[:admin]) ||
      (
        user == record.influencer.user && current_role == User::USER_ROLES[:influencer] &&
        user.influencer.reviewed
      )
      record_attributes
    end
  end
end
