class ProjectReviewer < ApplicationRecord
  belongs_to :project
  belongs_to :reviewer

  validates_presence_of :feedback
end
