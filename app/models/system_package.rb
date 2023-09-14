class SystemPackage < ApplicationRecord
  has_many :system_package_resources
  has_many :organization_system_packages
  has_many :organizations, through: :organization_system_packages

  validates_presence_of :entity_name, :package_name, :package_description, :gross_price, :fee
  validates_numericality_of :fee, :gross_price, :discount, only_float: true, greater_than_equal_to: 0.00
  validates :discount_expires_at, :start_time, comparison: { greater_than_equal_to: DateTime.current }
  validates :end_time, comparison: { greater_than: :start_time }
end
