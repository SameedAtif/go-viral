class Reviewer < ApplicationRecord
  belongs_to :user

  has_many :project_reviews
  has_many :organization_reviews
  has_many :gig_reviews
  has_many :project_disputes
end
