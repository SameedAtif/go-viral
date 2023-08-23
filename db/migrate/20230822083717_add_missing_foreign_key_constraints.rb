class AddMissingForeignKeyConstraints < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :verified, :boolean
    add_reference :organization_feedbacks, :influencer, foreign_key: true
  end
end
