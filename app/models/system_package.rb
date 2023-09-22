class SystemPackage < ApplicationRecord
  has_many :system_package_resources
  accepts_nested_attributes_for :system_package_resources,
                                allow_destroy: true
  has_many :organization_system_packages
  has_many :organizations, through: :organization_system_packages

  CUSTOM_PACKAGE_FEE = 0.10
  BASIC_PACKAGE_FEE = 0.05
  PAYMENT_PLAN_TYPES = {
    month: 'month',
    year: 'year'
  }
  PAYMENT_PLANS = PAYMENT_PLAN_TYPES.values
  ENTITY_NAME_TYPES = {
    influencer: 'influencer',
    client: 'client'
  }.freeze
  ENTITY_NAMES = ENTITY_NAME_TYPES.values

  validates_presence_of :entity_name, :package_name, :package_description, :gross_price, :fee
  validates_numericality_of :fee, :gross_price, :discount, only_float: true, greater_than_or_equal_to: 0.00, allow_blank: true
  validates :discount_expires_at, comparison: { greater_than_or_equal_to: DateTime.current }, allow_blank: true
  validates_inclusion_of :entity_name, in: ENTITY_NAMES
  validates_inclusion_of :payment_plan, in: PAYMENT_PLANS, allow_blank: true

  def total_price
    gross_price + gross_price * fee
  end
end
