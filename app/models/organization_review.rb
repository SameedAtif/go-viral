class OrganizationReview < ApplicationRecord
  belongs_to :organization
  belongs_to :reviewer

  validates_presence_of :feedback
end
