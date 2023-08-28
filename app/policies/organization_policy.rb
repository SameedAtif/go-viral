class OrganizationPolicy < ApplicationPolicy
  def update?
    # Also add if the user is a reviewer
    (user == record.owner.user && current_role == User::USER_ROLES[:client]) || user.reviewer?
  end

  def permitted_attributes
    record_attributes = [
      :id, :name, :address_1, :address_2, :city, :country, :phone_number,
      :website_url, :facebook_url, :instagram_url, :tiktok_url, :youtube_url
    ]
    if (user.admin? && current_role == User::USER_ROLES[:admin]) || record.owner.user
      record_attributes
    elsif (user.reviewer? && current_role == User::USER_ROLES[:reviewer])
      record_attributes << :verified
      record_attributes << :reviewer_id
    end
  end
end
