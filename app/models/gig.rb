class Gig < ApplicationRecord
  belongs_to :influencer

  # One Gig can be bought by multiple clients
  has_many :gig_clients
  has_many :clients, through: :gig_clients
  # One Gig can have multiple platforms
  has_many :gig_platforms, dependent: :destroy
  has_many :platforms, through: :gig_platforms

  #One Gig can have multiple categories
  has_many :gig_categories

  validates_presence_of :title
  validates_length_of :title, minimum: 3
end
