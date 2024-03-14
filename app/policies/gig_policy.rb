class GigPolicy < ApplicationPolicy
  def edit?
    (user.influencer == record.influencer && current_role == User::USER_ROLES[:influencer]) ||
    (user.reviewer? && current_role == User::USER_ROLES[:reviewer])
  end

  def update?
    (user.influencer == record.influencer && current_role == User::USER_ROLES[:influencer]) ||
    (user.reviewer? && current_role == User::USER_ROLES[:reviewer])
  end

  def new?
    current_role == User::USER_ROLES[:influencer] && user.influencer.reviewed
  end

  def create?
    current_role == User::USER_ROLES[:influencer] && user.influencer.reviewed
  end

  def permitted_attributes
    record_attributes = [
      :id, :title, :description, :targeted_demographic_start_age, :targeted_demographic_end_age,
      gig_packages_attributes: [:id, :gig_id, :title, :description, :price, :delivery_estimation, :review_limit, :_destroy, features: []],
      gig_platforms_attributes: %i[id gig_id platform_id _destroy],
      gig_faqs_attributes: %i[id gig_id question answer],
      gig_categories_attributes: %i[id category_id _destroy],
      targeted_geographic_audience: [],
      targeted_geographic_audience_city: []
    ]
    if user.reviewer? && current_role == User::USER_ROLES[:reviewer]
      %i[id status reviewed feedback reviewer_id]
    else
      record_attributes
    end
  end
end
