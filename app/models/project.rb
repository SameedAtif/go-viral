class Project < ApplicationRecord
  belongs_to :client
  # One Project can have many project-milestones
  has_many :project_applications
  has_many :project_milestones, dependent: :destroy
  accepts_nested_attributes_for :project_milestones,
                                allow_destroy: true
  has_many :project_categories, dependent: :destroy
  accepts_nested_attributes_for :project_categories,
                                allow_destroy: true
  has_many :example_works, dependent: :destroy
  accepts_nested_attributes_for :example_works,
                                allow_destroy: true

  has_many :project_deliverable_reviews
  # One Project can have multiple influencers
  has_many :project_influencers, dependent: :destroy
  has_many :influencers, through: :project_influencers
  # One Project can have multiple platforms
  has_many :project_platforms, dependent: :destroy
  has_many :platforms, through: :project_platforms
  accepts_nested_attributes_for :project_platforms,
                                allow_destroy: true

  validates_presence_of :title, :description
  validates :budget, presence: true, numericality: { only_float: true }
  validates_length_of :title, :description, minimum: 3

  # remove project duration
  # project -> expire-time # will expire the campaign after this
  # project -> status # will decide if we want to show it in the listing or not
  # project -> start-time # Start time of the campaign
  # project -> end-time # End time of the campaign
  # project -> number-of-influencers # How many influencers they are willing to hire
  # project -> project-application -> delivery-date # Influencer deadline
  # project -> project-milestones -> project id
  # project -> project milestones -> milestone title
  # project -> project milestones -> milestone description
  # project -> project milestones -> milestone expected reach goal
  # project -> project milestones -> milestone expected conversion goal
  # project -> project-deliverables -> milestone id
  # project -> project-deliverables -> influencer id
  # project -> project-deliverables -> project id
  # project -> project-deliverables -> title
  # project -> project-deliverables -> description
  # project -> project-deliverables -> file
  # project -> project-milestone-review -> milestone id
  # project -> project-milestone-review -> influencer id
  # project -> project-milestone-review -> project id
  # project -> project-milestone-review -> client id
  # project -> project-milestone-review -> milestone acheived reach goal
  # project -> project-milestone-review -> milestone acheived conversion goal

  # How will we measure/validate client satisfaction and influencer promises?

  # Project flow
  # Client will create a project.
  # Client will add the category and the relevant platforms
  # Client will set the budget and campaign start/end date
  # Client will set Also set the hiring expire date and also the system will set the status to hiring
  # Or schedule a job accordingly.
  # Client will also add project-milestones and milestone details.
  # Influencers that fall under that category will see it in there feed. Or notified if enabled.
  # Influencer will create a project application
  # Influencer will set there budget, delivery-time and sign any confidentiality that is required.
  # Influencer will submit the application
  # Client will be notified and can we view the application on his dashboard and in project#show
  # Client can view influencer profile
  # Client can set the project-application status
  # If status is "accepted" Influencer will be added to the campaign (Project Influencer record)
  # Influencer will be notified
  # Influencer will communicate with the client through the platform
  # Campaign will start
  # Influence will deliver the milestone (project-deliverable form).
  # Client will be notified
  # After completing milestone. Client will be asked to fill a survey and if they want to close the campaign or continue
  # If client choose "close" the project will be closed.
  # If client choose "continue" next milestone will start and influencer will be paid for the closed milestone.
  # At the end of campaign lifecycle. Client will be asked to review the Influencer performace (project-influencer-> feedback).
  # Project flow would end
  # Project would be marked as closed.

  # Future plan:
  # Currently Client can choose different payment plans (merch/coupon/other)
  # In future, client will be charged for payment service
  # For merch and other payment ways, platform will not be responsible for any disputes.
end
