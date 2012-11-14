class AddFieldsToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :gratuity_applies, :boolean, default: false
    add_column :countries, :minimum_vacation_days, :integer, default: 21
    add_column :countries, :vacation_by_working_days, :boolean, default: false
  end
end
