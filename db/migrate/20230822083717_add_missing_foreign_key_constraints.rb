class AddMissingForeignKeyConstraints < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :verified, :boolean
    add_reference :organization_feedbacks, :influencer, foreign_key: true

    create_table :reviewers do |t|
      t.references :user, foreign_key: true

      t.timestamps
    end
    create_table :project_reviews do |t|
      t.references :project, foreign_key: true
      t.references :reviewer, foreign_key: true
      t.string :status
      t.string :feedback

      t.timestamps
    end

    create_table :organization_reviews do |t|
      t.references :organization, foreign_key: true
      t.references :reviewer, foreign_key: true
      t.string :status
      t.string :feedback

      t.timestamps
    end

    create_table :gig_reviews do |t|
      t.references :gig, foreign_key: true
      t.references :reviewer, foreign_key: true
      t.string :status
      t.string :feedback

      t.timestamps
    end

    add_reference :projects, :reviewer, foreign_key: true
    add_reference :gigs, :reviewer, foreign_key: true
    add_reference :influencers, :reviewer, foreign_key: true

    add_column :gigs, :reviewed, :boolean
    add_column :influencers, :reviewed, :boolean
  end
end
