class Organization < ApplicationRecord
  has_many :organization_details, dependent: :destroy
  has_many :clients, through: :organization_details

  validates_presence_of :name, :address_1, :address_2, :city, :country, :phone_number
end
