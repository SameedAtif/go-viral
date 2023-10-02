class ProjectMilestone < ApplicationRecord
  belongs_to :project

  has_many :project_deliverables

  validates_presence_of :title, :description, :start_time, :end_time
  validates :budget, presence: true, numericality: { only_float: true }
  validates :conversion, :reach, presence: true, numericality: { only_integer: true }
  validates :end_time, comparison: { greater_than: :start_time }
  validates_length_of :title, :description, minimum: 3

  validate :start_time_greater_than_equal_to_project_start_time
  validate :end_time_less_than_equal_to_project_end_time

  private

  def start_time_greater_than_equal_to_project_start_time
    return if start_time >= project.start_time

    errors.add(:start_time, "Start time should be greater than equal to project start time")
  end

  def end_time_less_than_equal_to_project_end_time
    return if end_time <= project.end_time

    errors.add(:end_time, "End time should be less than equal to project end time")
  end
end
