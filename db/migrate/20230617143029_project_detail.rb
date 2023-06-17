class ProjectDetail < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :description, :string, null: false, default: ""
    add_column :projects, :budget, :float, null: false, default: 0.0
    add_column :projects, :duration, :interval
  end
end
