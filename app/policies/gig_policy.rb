class GigPolicy < ApplicationPolicy
  def edit?
    user == (record.influencer && current_role == User::USER_ROLES[:influencer]) || user.reviewer?
  end

  def update?
    (user == record.influencer && current_role == User::USER_ROLES[:influencer]) || user.reviewer?
  end

  def new?
    current_role == User::USER_ROLES[:influencer]
  end

  def create?
    current_role == User::USER_ROLES[:influencer]
  end

  def permitted_attributes
    record_attributes = [
      :id, :title, :description,
      { gig_categories_attributes: %i[id gig_id title description price delivery_estimation review_limit _destroy],
        gig_platforms_attributes: %i[id gig_id _destroy],
        gig_faqs_attributes: %i[id gig_id question answer] }
    ]
    if user.reviewer? && current_role == User::USER_ROLES[:reviewer]
      %i[id status reviewed feedback reviewer_id]
    end
  end
end
