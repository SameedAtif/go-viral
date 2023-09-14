class PaymentArchitecture < ActiveRecord::Migration[7.0]
  # organization_system_package
  # - nested attribute when an organization is created.
  # - organization_id, package_name: ('basic', 'premium', 'pro', 'custom'), package_description, discound: 0.10, discount_expires_at: DateTime
  # organization_system_package_resources
  # - for custom organization_system_package -> nested attributes passed with organization_system_package.
  # - organization_system_package_id, resource_name: (project, influencer), property: (class, column_name), operation: (less than, equal-to), operation_value: ("true|, "10", "string")
  ## In case the above values are updated.
  ## Below values are non-mutable. Meaning no-one can update transaction records once they are created
  # organization_system_package_transaction
  # - created when organization_system_package resource is made.
  # - organization_system_package_id, name: , description: , amount:, discout:, discount_expires_at:, transaction_token
  # organization_system_package_resource_transaction
  # - organization_system_package_id, resource_name: (project, influencer), property: (self, column_name), operation: (less than, equal-to), operation_value: ("true|, "10", "string")

  def change
    create_table :system_packages do |t|
      t.string :entity_name, null: false
      t.string :package_name, null: false
      t.string :package_description, null: false
      t.float :gross_price, precision: 64, scale: 12
      t.float :fee, precision: 64, scale: 12
      t.float :discount, precision: 64, scale: 12
      t.datetime :discount_expires_at
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

      t.timestamps
    end

    create_table :organization_system_packages do |t|
      t.belongs_to :organization, foreign_key: true, index: true
      t.belongs_to :system_package, foreign_key: true, index: true
      t.boolean :refunded, default: false

      t.timestamps
    end

    create_table :organization_system_package_transactions do |t|
      t.belongs_to :organization_system_package, foreign_key: true, index: {name: "index_org_sys_pkg_on_org_sys_pkg_trans"}
      t.belongs_to :client, foreign_key: true, index: true
      t.string :transaction_type, null: false
      t.string :package_name, null: false
      t.string :package_description, null: false
      t.string :transaction_token, null: false
      t.float :gross_price, precision: 64, scale: 12
      t.float :fee, precision: 64, scale: 12
      t.float :discount, precision: 64, scale: 12
      t.datetime :discount_expires_at
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

      t.timestamps
    end

    create_table :system_package_resources do |t|
      t.belongs_to :system_package, foreign_key: true, index: true
      t.string :resource_name, null: false
      t.string :property_name
      t.string :property_type
      t.string :operation, null: false
      t.string :operation_value, null: false
      t.float :gross_price, precision: 64, scale: 12
      t.float :fee, precision: 64, scale: 12
      t.float :discount, precision: 64, scale: 12
      t.datetime :discount_expires_at

      t.timestamps
    end

    create_table :organization_system_package_resources do |t|
      t.belongs_to :organization_system_package, foreign_key: true, index: {name: "index_org_sys_pkg_r_on_org_sys_pkg"}
      t.belongs_to :system_package_resource, foreign_key: true, index: {name: "index_org_sys_pkg_r_on_sys_pkg_r"}

      t.timestamps
    end

    create_table :organization_system_package_resource_transactions do |t|
      t.belongs_to :organization_system_package_transaction, foreign_key: true, index: {name: "index_org_sys_pkg_r_trans_on_org_sys_pkg_trans"}
      t.belongs_to :organization_system_package_resource, foreign_key: true, index: {name: "index_org_sys_pkg_r_trans_on_org_sys_pkg_r"}
      t.string :resource_name, null: false
      t.string :property_name
      t.string :property_type
      t.string :operation, null: false
      t.string :operation_value, null: false
      t.float :gross_price, precision: 64, scale: 12
      t.float :fee, precision: 64, scale: 12
      t.float :discount, precision: 64, scale: 12
      t.datetime :discount_expires_at


      t.timestamps
    end

    create_table :system_project_transactions do |t|
      t.belongs_to :project_application, foreign_key: true, index: true
      t.belongs_to :project, foreign_key: true, index: true
      t.belongs_to :client, foreign_key: true, index: true
      t.float :gross_price, precision: 64, scale: 12
      t.float :fee, precision: 64, scale: 12

      t.string :transaction_type, null: false
      t.string :transaction_token, null: false

      t.timestamps
    end

    create_table :influencer_project_transactions do |t|
      t.belongs_to :system_project_transaction, foreign_key: true, index: {name: "index_inf_proj_trans_on_sys_proj_trans"}
      t.belongs_to :project, foreign_key: true, index: true
      t.belongs_to :project_application, foreign_key: true, index: true
      t.belongs_to :influencer, foreign_key: true, index: true
      t.float :gross_price, precision: 64, scale: 12
      t.float :fee, precision: 64, scale: 12

      t.string :transaction_type, null: false
      t.string :transaction_token, null: false

      t.timestamps
    end

    create_table :client_project_transactions do |t|
      t.belongs_to :system_project_transaction, foreign_key: true, index: {name: "index_clnt_proj_trans_on_sys_proj_trans"}
      t.belongs_to :project_application, foreign_key: true, index: true
      t.belongs_to :project, foreign_key: true, index: true
      t.belongs_to :client, foreign_key: true, index: true
      t.float :gross_price, precision: 64, scale: 12
      t.float :fee, precision: 64, scale: 12

      t.string :transaction_type, null: false
      t.string :transaction_token, null: false

      t.timestamps
    end

    add_column :organizations, :payment_plan, :string, null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
