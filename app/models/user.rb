class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  has_one :influencer, dependent: :destroy
  has_one :client, dependent: :destroy
  has_one :reviewer, dependent: :destroy

  USER_ROLES = {
    client: 'client',
    influencer: 'influencer',
    reviewer: 'reviewer',
    admin: 'admin'
  }.freeze

  validates_inclusion_of :user_roles, in: USER_ROLES.values, allow_blank: true

  User::USER_ROLES.values.each do |role|
    User.define_method("#{role}?".to_sym) do
      user_roles.include?(role)
    end
  end
end
