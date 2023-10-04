class Gig < ApplicationRecord
  belongs_to :influencer
  belongs_to :reviewer, optional: true

  # One Gig can be bought by multiple clients
  has_many :gig_clients
  has_many :clients, through: :gig_clients
  # One Gig can have multiple platforms
  has_many :gig_platforms, dependent: :destroy
  has_many :platforms, through: :gig_platforms

  #One Gig can have multiple categories
  has_many :gig_packages
  has_many :gig_reviews
  has_many :gig_faqs

  STATUSES_MAP = {
    draft: 'draft',
    pending: 'pending_review',
    in_review: 'in_review',
    approved: 'approved',
    rejected: 'rejected',
    published: 'published',
  }.freeze
  STATUSES = STATUSES_MAP.values

  validates_presence_of :title, :status, :description
  validates_length_of :title, :description, minimum: 3
  validates :targeted_demographic_end_age, comparison: { greater_than: :targeted_demographic_start_age }
  validates :status, inclusion: { in: STATUSES }

  scope :approved, -> { where(status: Gig::STATUSES[:approved]) }
  scope :in_review, -> { where(status: Gig::STATUSES[:in_review]) }
  scope :pending, -> { where(status: Gig::STATUSES[:pending]) }

  after_save_commit :notify_reviewer, :notify_creator, if: -> { saved_change_to_attribute?('status') }

  private

  def notify_reviewer
    return unless status == STATUSES_MAP[:pending_review] || new_record?

    Reviewer.all.pluck(:user_id).each do |user_id|
      Notification.create!(
        resource_id: id,
        resource_type: self.class.name,
        user_id: user_id,
        user_type: User::USER_ROLES[:reviewer],
        notification_type: Notification::NOTIFICATION_TYPES_MAP[:reviewer_pending_gig_review]
      )
    end
  end

  def notify_creator
    return unless [STATUSES_MAP[:approved], STATUSES_MAP[:rejected], STATUSES_MAP[:in_review]].include?(status)

    Notification.create!(
      resource_id: id,
      resource_type: self.class.name,
      user_id: influencer.user_id,
      user_type: User::USER_ROLES[:influencer],
      notification_type: creator_notification_type
    )
  end

  def creator_notification_type
    if status == STATUSES_MAP[:approved]
      Notification::NOTIFICATION_TYPES_MAP[:creator_gig_approved]
    elsif status == STATUSES_MAP[:rejected]
      Notification::NOTIFICATION_TYPES_MAP[:creator_gig_rejected]
    elsif status == STATUSES_MAP[:in_review]
      Notification::NOTIFICATION_TYPES_MAP[:creator_gig_in_review]
    end
  end
end
