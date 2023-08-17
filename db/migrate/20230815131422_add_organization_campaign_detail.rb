class AddOrganizationCampaignDetail < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :website_url, :string
    add_column :organizations, :facebook_url, :string
    add_column :organizations, :instagram_url, :string
    add_column :organizations, :linkedin_url, :string
    add_column :organizations, :youtube_url, :string
    add_column :organizations, :tiktok_url, :string

    create_table :categories do |t|
      t.string :name
      t.string :description

      t.timestamps
    end

    create_table :organization_feedbacks do |t|
      t.decimal :score, precision: 64, scale: 12
      t.string :title
      t.string :description
      t.belongs_to :organization, foreign_key: true

      t.timestamps
    end


    create_table :project_categories do |t|
      t.belongs_to :project, foreign_key: true
      t.belongs_to :category, foreign_key: true

      t.timestamps
    end

    add_column :projects, :payment_type, :string
    add_column :projects, :target_audience, :string
    add_column :projects, :payment_verified, :boolean
    add_column :projects, :reviewed, :boolean
    add_column :projects, :is_draft, :boolean

    create_table :example_works do |t|
      t.string :title
      t.string :description
      t.belongs_to :project, foreign_key: true

      t.timestamps
    end

    add_column :projects, :views, :integer
  end
end
