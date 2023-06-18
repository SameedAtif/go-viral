class AddBioToInfluencers < ActiveRecord::Migration[7.0]
  def change
    add_column :influencers, :bio, :string
  end
end
