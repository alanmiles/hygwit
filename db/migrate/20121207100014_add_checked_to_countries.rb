class AddCheckedToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :checked, :boolean, default: false
    add_column :countries, :updated_by, :integer, default: 1
  end
end
