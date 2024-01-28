class Gig < ApplicationRecord
  belongs_to :influencer
  belongs_to :reviewer, optional: true

  # One Gig can be bought by multiple clients
  has_many :gig_clients
  has_many :clients, through: :gig_clients
  # One Gig can have multiple platforms
  has_many :gig_platforms, dependent: :destroy
  has_many :platforms, through: :gig_platforms
  accepts_nested_attributes_for :gig_platforms,
                                allow_destroy: true

  #One Gig can have multiple categories
  has_many :gig_packages, dependent: :destroy
  accepts_nested_attributes_for :gig_packages,
                                allow_destroy: true
  has_many :gig_reviews, dependent: :nullify
  has_many :gig_faqs, dependent: :destroy
  accepts_nested_attributes_for :gig_faqs,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes['question'].blank? }
  has_many :client_gig_reviews, dependent: :nullify
  has_many :influencer_gig_transactions, dependent: :nullify

  STATUSES_MAP = {
    draft: 'draft',
    pending_review: 'pending_review',
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

  scope :draft, -> { where(status: Gig::STATUSES_MAP[:draft]) }
  scope :pending_review, -> { where(status: Gig::STATUSES_MAP[:pending_review]) }
  scope :in_review, -> { where(status: Gig::STATUSES_MAP[:in_review]) }
  scope :approved, -> { where(status: Gig::STATUSES_MAP[:approved]) }
  scope :rejected, -> { where(status: Gig::STATUSES_MAP[:rejected]) }
  scope :published, -> { where(status: Gig::STATUSES_MAP[:published]) }

  has_rich_text :description

  after_save_commit :notify_reviewer, :notify_creator, if: -> { saved_change_to_attribute?('status') }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "influencer_id", "reviewed", "reviewer_id", "status", "targeted_demographic_end_age", "targeted_demographic_start_age", "targeted_geographic_audience", "title", "updated_at", "views"]
  end

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
