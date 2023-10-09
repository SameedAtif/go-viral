class GigSupportModule < ActiveRecord::Migration[7.0]
  def change
    remove_reference :gig_clients, :gig_category, index: true
    rename_table :gig_categories, :gig_packages
    add_reference :gig_clients, :gig_package, foreign_key: true, index: true
    add_column :gig_packages, :features, :string, array: true, default: []
    add_column :gigs, :targeted_demographic_start_age, :integer
    add_column :gigs, :targeted_demographic_end_age, :integer
    add_column :gigs, :targeted_geographic_audience, :string, array: true, default: []
    add_column :gig_clients, :status, :string, default: GigClient::STATUSES_MAP[:pending_review]

    create_table :client_gig_reviews do |t|
      t.belongs_to :gig, foreign_key: true, index: true
      t.belongs_to :client, foreign_key: true, index: true
      t.belongs_to :gig_package, foreign_key: true, index: true

      t.string :title, null: false
      t.string :description
      t.float :rating, null: false, default: 0.00
      t.timestamps
    end

    create_table :gig_disputes do |t|
      t.belongs_to :gig_client, foreign_key: true, index: true
      t.belongs_to :reviewer, foreign_key: true, index: true

      t.string :created_by # influencer or client
      t.string :status, null: false, default: GigDispute::STATUS_TYPES_MAP[:pending_review] #pending_review, under_review, resolved
      t.string :resolved_in_favor
      t.string :detail

      t.datetime :resolved_at

      t.timestamps
    end

    create_table :system_gig_transactions do |t|
      t.belongs_to :gig_package, foreign_key: true, index: true
      t.belongs_to :client, foreign_key: true, index: true
      t.belongs_to :gig_dispute, foreign_key: true, index: true
      t.float :gross_price, precision: 64, scale: 12
      t.float :fee, precision: 64, scale: 12

      t.string :transaction_type, null: false
      t.string :transaction_token, null: false

      t.timestamps
    end

    add_reference :gig_clients, :system_gig_transaction, foreign_key: true, index: true

    create_table :influencer_gig_transactions do |t|
      t.belongs_to :system_gig_transaction, foreign_key: true, index: {name: "index_inf_gig_trans_on_sys_gig_trans"}
      t.belongs_to :gig, foreign_key: true, index: true
      t.belongs_to :gig_client, foreign_key: true, index: true
      t.belongs_to :influencer, foreign_key: true, index: true
      t.float :gross_price, precision: 64, scale: 12
      t.float :fee, precision: 64, scale: 12
      t.boolean :credited
      t.datetime :credited_at
      t.string :transaction_type
      t.string :transaction_token

      t.timestamps
    end

    create_table :client_gig_transactions do |t|
      t.belongs_to :system_gig_transaction, foreign_key: true, index: {name: "index_clnt_gig_trans_on_sys_gig_trans"}
      t.belongs_to :gig_client, foreign_key: true, index: true
      t.belongs_to :client, foreign_key: true, index: true
      t.float :gross_price, precision: 64, scale: 12
      t.float :fee, precision: 64, scale: 12
      t.boolean :credited
      t.datetime :credited_at
      t.string :transaction_type
      t.string :transaction_token

      t.timestamps
    end

    create_table :gig_deliverables do |t|
      t.belongs_to :gig_client, foreign_key: true
      t.string :title, null: false, default: ""
      t.string :description, null: false

      t.timestamps
    end

    create_table :gig_deliverable_reviews do |t|
      t.belongs_to :client, foreign_key: true
      t.belongs_to :gig_client, foreign_key: true
      t.belongs_to :gig_deliverable, foreign_key: true
      t.string :remarks, null: false, default: ""
      t.string :status, null: false, default: 'ready_for_review'
      t.float :rating

      t.timestamps
    end

    create_table :influencer_portfolios do |t|
      t.belongs_to :influencer, foreign_key: true, index: true
      t.string :title
      t.string :description

      t.timestamps
    end

  end
end
