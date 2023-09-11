class OrganizationDetail < ApplicationRecord
  belongs_to :client
  belongs_to :organization

  CLIENT_ROLES_MAP = {
    owner: 'owner'
  }.freeze
  CLIENT_ROLES = CLIENT_ROLES_MAP.values

  validates_presence_of :client_role
  validates :client_role, inclusion: { in: CLIENT_ROLES }
end
