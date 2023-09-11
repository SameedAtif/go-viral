class ProjectApplicationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.client.present? && current_role == User::USER_ROLES[:client]
        scope
      else
        []
      end
    end
  end

  def edit?
    # Also add if the user is a reviewer
    (user == record.influencer.user && current_role == User::USER_ROLES[:influencer] && user.influencer.reviewed)
  end

  def update?
    # Also add if the user is a reviewer
    (user == record.influencer.user && current_role == User::USER_ROLES[:influencer] && user.influencer.reviewed) ||
    (user == record.project.organization.owner.user && current_role == User::USER_ROLES[:client])
  end

  def new?
    # Also add if the user is a reviewer
    current_role == User::USER_ROLES[:influencer] && user.influencer.reviewed
  end

  def create?
    # Also add if the user is a reviewer
    user == record.influencer.user && current_role == User::USER_ROLES[:influencer] && user.influencer.reviewed
  end

  def permitted_attributes
    record_attributes = [
      :id, :title, :description, :budget, :delivery_date
    ]
    if (user.admin? && current_role == User::USER_ROLES[:admin]) ||
      (user == record.influencer.user && current_role == User::USER_ROLES[:influencer] && user.influencer.reviewed)
      record_attributes
    elsif (user == record.project.organization.owner.user && current_role == User::USER_ROLES[:client])
      [:id, :status]
    end
  end
end
