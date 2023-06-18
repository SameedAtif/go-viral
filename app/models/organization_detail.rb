class OrganizationDetail < ApplicationRecord
  belongs_to :client
  belongs_to :organization

  validates_presence_of :client_role
end
