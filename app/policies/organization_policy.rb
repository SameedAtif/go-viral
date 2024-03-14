class OrganizationPolicy < ApplicationPolicy
  def edit?
    (user == record.owner.user && current_role == User::USER_ROLES[:client]) ||
    (user.reviewer? && current_role == User::USER_ROLES[:reviewer])
  end

  def update?
    # Also add if the user is a reviewer
    (user == record.owner.user && current_role == User::USER_ROLES[:client]) ||
    (user.reviewer? && current_role == User::USER_ROLES[:reviewer])
  end

  def permitted_attributes
    record_attributes = [
      :name, :address_1, :address_2, :city, :country, :phone_number, :payment_plan,
      :website_url, :facebook_url, :instagram_url, :tiktok_url, :youtube_url, :linkedin_url,
      :targeted_demographic_start_age, :targeted_demographic_end_age, categories: [], platforms: [],
      targeted_geographic_audience: [],
      targeted_geographic_audience_city: []
    ]
    if record.owner.user == user
      record_attributes
    elsif (user.reviewer? && current_role == User::USER_ROLES[:reviewer])
      [
        :id,
        :verified,
        :reviewer_id
      ]
    end
  end
end
