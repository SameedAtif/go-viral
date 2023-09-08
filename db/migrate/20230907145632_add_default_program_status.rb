class AddDefaultProgramStatus < ActiveRecord::Migration[7.0]
  def change
    reversible do |change|
      change.up do
        change_column :projects, :status, :string, default: Project::STATUSES_MAP[:pending_review]
        remove_column :projects, :target_audience
      end
      change.down do
        change_column :projects, :status, :string, default: nil
        add_column :projects, :target_audience, :string
      end
    end
    add_column :projects, :targeted_demographic_start_age, :integer
    add_column :projects, :targeted_demographic_end_age, :integer
    add_column :projects, :targeted_geographic_audience, :string, array: true, default: []
  end
end
