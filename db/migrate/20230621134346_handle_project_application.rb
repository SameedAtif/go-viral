class HandleProjectApplication < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :start_time, :datetime
    add_column :projects, :end_time, :datetime
    add_column :projects, :required_number_of_influencers, :integer, null: false, default: 1

    add_column :project_applications, :delivery_date, :datetime

    create_table :project_milestones do |t|
      t.belongs_to :project, foreign_key: true
      t.string :title, null: false, default: ""
      t.string :description, null: false, default: ""
      t.integer :reach, null: false
      t.integer :conversion, null: false
      t.float :budget, null: false, default: 0.0

      t.timestamps
    end

    create_table :project_deliverables do |t|
      t.belongs_to :project_milestone, foreign_key: true
      t.belongs_to :influencer, foreign_key: true
      t.string :title, null: false, default: ""
      t.string :description, null: false

      t.timestamps
    end

    create_table :project_deliverable_reviews do |t|
      t.belongs_to :client, foreign_key: true
      t.belongs_to :project, foreign_key: true
      t.belongs_to :project_deliverable, foreign_key: true
      t.integer :achieved_reach, null: false, default: 0
      t.integer :achieved_conversion, null: false, default: 0
      t.string :remarks, null: false, default: ""
      t.float :rating

      t.timestamps
    end

    reversible do |change|
      change.up do
        remove_column :projects, :duration
      end

      change.down do
        add_column :projects, :duration, :interval
      end
    end
  end
end
