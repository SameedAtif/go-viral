class Category < ApplicationRecord
  # One Category can have multiple gigs
  has_many :gig_categories, dependent: :destroy
  has_many :gigs, through: :gig_categories
  # One Categorry can have multiple projects
  has_many :project_categories, dependent: :destroy
  has_many :projects, through: :project_categories

  validates_presence_of :name, :description
end
