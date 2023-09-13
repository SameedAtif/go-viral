class OrganizationSystemPackage < ApplicationRecord
  belongs_to :organization

  validates_presence_of :package_name, :package_description, :gross_price, :fee
  validates_numericality_of :fee, :gross_price, :discount, only_float: true, greater_than_equal_to: 0.00
  validates :discount_expires_at, comparison: { greater_than_equal_to: DateTime.current }
end
