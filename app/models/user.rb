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
      user_roles.include?(role) || public_send(role.to_sym).present?
    end
  end

  def broadcast_update
    broadcast_replace_to 'user_status', partial: 'users/status', user: self
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["confirmation_sent_at", "confirmation_token", "confirmed_at", "created_at", "current_sign_in_at", "current_sign_in_ip", "email", "encrypted_password", "failed_attempts", "first_name", "id", "last_name", "last_sign_in_at", "last_sign_in_ip", "locked_at", "phone_number", "remember_created_at", "reset_password_sent_at", "reset_password_token", "sign_in_count", "status", "unconfirmed_email", "unlock_token", "updated_at", "user_roles"]
  end
end
