class SystemPackageResource < ApplicationRecord
  # TODO: resource discount expire date should match package discount date
  # TODO: validate resource_value based on resource_name
  belongs_to :system_package

  has_many :organization_system_package_resources

  BASE_CAMPAIGN_PRICE = 3000.freeze
  BASE_CREATOR_PRICE = 1000.freeze
  BASE_GIG_PRICE = 500.freeze
  BASE_FEE = 0.05

  RESOURCE_NAME_TYPES = {
    number_of_projects: 'number_of_projects',
    number_of_influencers: 'number_of_influencers',
    number_of_gigs: 'number_of_gigs'
  }.freeze
  RESOURCE_NAMES = RESOURCE_NAME_TYPES.values
  CATEGORY_TYPES = {
    free: 'free',
    paid: 'paid'
  }.freeze
  CATEGORIES = CATEGORY_TYPES.values
  BASIC_RESOURCE_VALUE_MAP = {
    project: 1,
    influencer: 2,
    gig: 5
  }

  validates_presence_of :resource_name, :resource_value, :gross_price, :fee
  validates_numericality_of :fee, :gross_price, :discount, only_float: true, greater_than_or_equal_to: 0.00, allow_blank: true
  validates :discount_expires_at, comparison: { greater_than_or_equal_to: DateTime.current }, allow_blank: true
  validates_inclusion_of :category, in: CATEGORIES
  validates_inclusion_of :resource_name, in: RESOURCE_NAMES


  def number_of_projects_price(quantity)
    total = quantity * BASE_CAMPAIGN_PRICE
    total + (total * BASE_FEE)
  end
end
