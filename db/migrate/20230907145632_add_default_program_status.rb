class AddDefaultProgramStatus < ActiveRecord::Migration[7.0]
  def change
    change_column :projects, :status, :string, default: Project::STATUSES_MAP[:pending_review]
  end
end
