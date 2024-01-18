class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  has_one :influencer, dependent: :destroy
  has_one :client, dependent: :destroy
  has_one :reviewer, dependent: :destroy
  has_many :messages

  enum status: %i[offline away online]

  after_create_commit { broadcast_append_to 'users' }
  after_update_commit { broadcast_update }

  USER_ROLES = {
    client: 'client',
    influencer: 'influencer',
    reviewer: 'reviewer',
    admin: 'admin'
  }.freeze

  USER_ROLES_VALUES = USER_ROLES.values

  validates_inclusion_of :user_roles, in: USER_ROLES_VALUES, allow_blank: true

  scope :all_except, ->(user) { where.not(id: user) }

  User::USER_ROLES_VALUES.each do |role|
    User.define_method("#{role}?".to_sym) do
      user_roles.include?(role)
    end
  end

  def broadcast_update
    broadcast_replace_to 'user_status', partial: 'users/status', user: self
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
