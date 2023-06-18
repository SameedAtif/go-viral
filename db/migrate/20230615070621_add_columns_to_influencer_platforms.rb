class AddColumnsToInfluencerPlatforms < ActiveRecord::Migration[7.0]
  def change
    add_column :influencer_platforms, :followers, :integer
    add_column :influencer_platforms, :reach, :float
    add_column :influencer_platforms, :url, :string
  end
end
