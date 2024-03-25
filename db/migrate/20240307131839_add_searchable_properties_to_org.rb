class AddSearchablePropertiesToOrg < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :targeted_demographic_start_age, :integer
    add_column :organizations, :targeted_demographic_end_age, :integer
    add_column :organizations, :targeted_geographic_audience, :string, array: true, default: []
    add_column :organizations, :targeted_geographic_audience_city, :string, array: true, default: []
    add_column :organizations, :platforms, :string, array: true, default: []
    add_column :organizations, :categories, :string, array: true, default: []
  end
end
