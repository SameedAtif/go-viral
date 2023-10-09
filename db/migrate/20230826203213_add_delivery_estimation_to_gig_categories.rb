class AddDeliveryEstimationToGigCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :gig_categories, :delivery_estimation, :integer,null: false, default: 1
    add_column :gig_categories, :review_limit, :integer, null: false, default: 1
  end
end
