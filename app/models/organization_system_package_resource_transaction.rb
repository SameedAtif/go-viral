class OrganizationSystemPackageResourceTransaction < ApplicationRecord
  belongs_to :organization_system_package_transaction
  belongs_to :organization_system_package_resource

  validates_presence_of :resource_name, :property_name, :property_type, :operation, :operation_value,
                        :gross_price, :fee
  validates_numericality_of :fee, :gross_price, :discount, only_float: true, greater_than_equal_to: 0.00
  validates :discount_expires_at, comparison: { greater_than_equal_to: DateTime.current }

  validate :match_with_system_package

  def readonly?
    !new_record?
  end

  private

  def match_with_system_package
    [:transaction_type, :transaction_token, :package_name, :package_description,
    :transaction_token, :gross_price, :fee, :discount, :discount_expires_at].each do |col|
      if self.send(col) != organization_system_package_resource.send(col)
        errors.add(col, "#{col.to_s} value must match organization_system_package.#{col}")
      end
    end
  end
end
