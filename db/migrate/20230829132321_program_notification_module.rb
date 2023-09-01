class ProgramNotificationModule < ActiveRecord::Migration[7.0]
  def change
    remove_reference :projects, :client, index: true, foreign_key: true
    add_reference :projects, :organization, index: true, foreign_key: true
  end
end
