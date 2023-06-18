class ClientInformation < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false, default: ""
      t.string :address_1, null: false, default: ""
      t.string :address_2, null: false, default: ""
      t.string :city, null: false, default: ""
      t.string :country, null: false, default: ""
      t.string :phone_number, null: false, default: ""

      t.timestamps
    end

    create_table :organization_details do |t|
      # For each organization there cannot be multiple same client
      t.belongs_to :client, foreign_key: true, index: { unique: true }
      t.belongs_to :organization, foreign_key: true
      t.string :client_role, null: false, default: ""

      t.timestamps
    end
  end
end
