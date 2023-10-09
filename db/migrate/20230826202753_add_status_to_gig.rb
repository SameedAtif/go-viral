class AddStatusToGig < ActiveRecord::Migration[7.0]
  def change
    add_column :gigs, :status, :string, default: "draft"
    add_column :gigs, :views, :integer, default: 0
  end
end
