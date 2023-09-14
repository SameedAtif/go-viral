class SystemPackageResource < ApplicationRecord
  belongs_to :system_package

  has_many :organization_system_package_resources

  validates_presence_of :resource_name, :property_name, :property_type, :operation, :operation_value,
                        :gross_price, :fee
  validates_numericality_of :fee, :gross_price, :discount, only_float: true, greater_than_equal_to: 0.00
  validates :discount_expires_at, comparison: { greater_than_equal_to: DateTime.current }
end
