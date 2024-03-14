class AddCityToGig < ActiveRecord::Migration[7.0]
  def change
    add_column :gigs, :targeted_geographic_audience_city, :string, array: true, default: []
    add_column :influencer_platforms, :targeted_geographic_audience_city, :string, array: true, default: []
  end
end
