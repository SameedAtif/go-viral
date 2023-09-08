class ProjectPolicy < ApplicationPolicy
  def edit?
    # Also add if the user is a reviewer
    (user == record.organization.owner.user && current_role == User::USER_ROLES[:client]) ||
    (user.reviewer? && current_role == User::USER_ROLES[:reviewer])
  end

  def update?
    # Also add if the user is a reviewer
    (user == record.organization.owner.user && current_role == User::USER_ROLES[:client]) ||
    (user.reviewer? && current_role == User::USER_ROLES[:reviewer])
  end

  def new?
    # Also add if the user is a reviewer
    user.client.organization.verified && current_role == User::USER_ROLES[:client]
  end

  def create?
    # Also add if the user is a reviewer
    user.client.organization.verified && current_role == User::USER_ROLES[:client]
  end

  def permitted_attributes
    record_attributes = [
      :id, :title, :description, :budget, :start_time, :end_time,
      :required_number_of_influencers, :payment_type,
      :targeted_demographic_start_age, :targeted_demographic_end_age,
      :is_draft, targeted_geographic_audience: [],
      project_platforms_attributes: %i[id platform_id _destroy],
      project_categories_attributes: %i[id category_id _destroy],
      project_milestones_attributes: %i[id title description reach conversion budget _destroy],
      example_works_attributes: %i[id title description _destroy]
    ]
    if (user.admin? && current_role == User::USER_ROLES[:admin]) ||
      record.organization.owner.user == user
      record_attributes
    elsif (user.reviewer? && current_role == User::USER_ROLES[:reviewer])
      [:id, :status, :reviewed, :payment_verified, :reviewer_id]
    end
  end
end
