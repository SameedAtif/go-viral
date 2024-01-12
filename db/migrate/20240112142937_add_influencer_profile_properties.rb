class AddInfluencerProfileProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :influencer_portfolios, :start_time, :datetime
    add_column :influencer_portfolios, :end_time, :datetime
    add_column :influencer_portfolios, :content_link, :string

    add_column :influencer_platforms, :targeted_demographic_start_age, :integer
    add_column :influencer_platforms, :targeted_demographic_end_age, :integer
    add_column :influencer_platforms, :targeted_geographic_audience, :string, array: true, default: []
  end
end
