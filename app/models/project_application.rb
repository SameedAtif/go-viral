class ProjectApplication < ApplicationRecord
  belongs_to :project
  belongs_to :influencer

  validates_presence_of :title, :description, :status
  validates_length_of :title, :description, minimum: 3

  after_update :create_project_influencer

  private

  def create_project_influencer
    return if status != 'approved' && saved_change_to_attribute?('status')

    project.project_influencers.find_or_create_by!(influencer: influencer)
  end
end
