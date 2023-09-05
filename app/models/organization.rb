class Organization < ApplicationRecord
  has_many :projects
  has_many :organization_reviews
  has_many :organization_details, dependent: :destroy
  has_many :clients, through: :organization_details

  validates_presence_of :name, :address_1, :address_2, :city, :country, :phone_number

  def owner
    organization_details.find_by(client_role: 'Owner').client
  end
end
