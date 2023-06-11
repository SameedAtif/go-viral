class SupportingEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :gig_categories do |t|
      t.belongs_to :gig, foreign_key: true
      t.string :title, null: false, default: ""
      t.string :description, null: false, default: ""
      t.float :price
    end

    create_table :project_applications do |t|
      t.belongs_to :project, foreign_key: true
      t.belongs_to :influencer, foreign_key: true
      t.string :title, null: false, default: ""
      t.string :description, null: false, default: ""
      t.string :status, null: false, default: ""
      t.float :budget
    end

    add_reference :gig_clients, :gig_category, foreign_key: true
  end
end
