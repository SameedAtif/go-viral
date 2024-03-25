class AddTimestampsToGigs < ActiveRecord::Migration[7.0]
  change_table :gigs do |t|
    t.timestamps null: true
  end
end
