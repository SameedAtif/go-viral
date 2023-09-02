class ProgramNotificationModule < ActiveRecord::Migration[7.0]
  def change
    remove_reference :projects, :client, index: true, foreign_key: true
    add_reference :projects, :organization, index: true, foreign_key: true
    add_reference :organizations, :reviewer, index: true, foreign_key: true

    create_table :notifications do |t|
      t.bigint  :resource_id, null: false
      t.string  :resource_type, null: false
      t.string  :user_type, null: false
      t.belongs_to :user, foreign_key: true
      t.string  :notification_type, null: false
      t.jsonb  :extra
      t.datetime  :read_at
      t.datetime  :cleared_at

      t.timestamps
    end

    add_index :notifications, [:resource_type, :resource_id]
  end
end
