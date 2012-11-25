class AddGratuityRuleToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :gratuity_ceiling_months, :integer
    add_column :countries, :gratuity_ceiling_value, :decimal, precision: 7, scale: 0
  end
end
