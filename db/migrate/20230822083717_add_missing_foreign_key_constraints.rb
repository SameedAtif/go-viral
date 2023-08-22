class AddMissingForeignKeyConstraints < ActiveRecord::Migration[7.0]
  def change
    add_reference :organization_feedbacks, :influencer, foreign_key: true
  end
end
