class OrganizationSystemPackageResource < ApplicationRecord
  belongs_to :organization_system_package
  belongs_to :system_package_resource

  has_many :organization_system_package_resource_transactions
end
