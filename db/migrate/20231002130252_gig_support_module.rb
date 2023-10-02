class GigSupportModule < ActiveRecord::Migration[7.0]
  def change
    rename_table :gig_categories, :gig_packages
    add_column :gig_packages, :features, :string, array: true, default: []
    add_column :gigs, :targeted_demographic_start_age, :integer
    add_column :gigs, :targeted_demographic_end_age, :integer
    add_column :gigs, :targeted_geographic_audience, :string, array: true, default: []
    add_column :gig_clients, :status, :string, default: GigClient::STATUSES_MAP[:pending_review]

    create_table :client_gig_reviews do |t|
      t.belongs_to :gig, foreign_key: true, index: true
      t.belongs_to :client, foreign_key: true, index: true
      t.belongs_to :gig_package, foreign_key: true, index: true

      t.string :title, null: false
      t.string :description
      t.float :rating, null: false, default: 0.00
      t.timestamps
    end
  end
end
