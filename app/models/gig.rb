class Gig < ApplicationRecord
  belongs_to :influencer

  # One Gig can be bought by multiple clients
  has_many :gig_clients, dependent: :destroy
  has_many :clients, through: :gig_clients, dependent: :destroy
  # One Gig can have multiple platforms
  has_many :gig_platforms, dependent: :destroy
  has_many :platforms, through: :gig_platforms, dependent: :destroy

  validates_presence_of :title
  validates_length_of :title, minimum: 3
end
