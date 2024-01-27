class GigDeliverable < ApplicationRecord
  include ValidFileTypes

  belongs_to :gig_client

  has_many :gig_deliverable_reviews

  has_many_attached :work_files

  validates_presence_of :title, :description
  validates_length_of :title, :description, minimum: 3

  validates :work_files, attached: true, content_type: IMAGE_CONTENT_TYPES,
                          size: { less_than: 5.megabytes, message: 'should be less than 5MB per file' },
                          limit: { min: 1, max: 3, message: 'should be between 1 and 3 files' }

  after_save_commit :notify_client, on: %i[create]

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
