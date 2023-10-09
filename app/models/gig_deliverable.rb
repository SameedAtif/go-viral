class GigDeliverable < ApplicationRecord
  belongs_to :gig_client

  has_many :gig_deliverable_reviews

  validates_presence_of :title, :description
  validates_length_of :title, :description, minimum: 3

  after_save_commit :notify_client, on: %i[create update]

  private

  def notify_client
    Notification.create!(
      resource_id: gig_client.gig.id,
      resource_type: gig_client.gig.class.name,
      user_id: gig_client.client.user_id,
      user_type: User::USER_ROLES[:client],
      notification_type: Notification::NOTIFICATION_TYPES_MAP[:client_creator_delivered_gig]
    )
  end
end
