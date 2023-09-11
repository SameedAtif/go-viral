class AddStatusToProjectDelivearbleReview < ActiveRecord::Migration[7.0]
  def change
    add_column :project_deliverable_reviews, :status, :string, default: ProjectDeliverableReview::STATUS_TYPES_MAP[:ready_for_review]
  end
end
