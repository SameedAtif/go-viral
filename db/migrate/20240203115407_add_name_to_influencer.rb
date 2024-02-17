class AddNameToInfluencer < ActiveRecord::Migration[7.0]
  def change
    add_column :influencers, :stage_name, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    create_table :gig_categories do |t|
      t.belongs_to :gig, foreign_key: true
      t.belongs_to :category, foreign_key: true

      t.timestamps
    end
  end
end
