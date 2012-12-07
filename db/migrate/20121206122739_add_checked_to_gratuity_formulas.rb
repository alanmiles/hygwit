class AddCheckedToGratuityFormulas < ActiveRecord::Migration
  def change
    add_column :gratuity_formulas, :checked, :boolean, default: false
    add_column :gratuity_formulas, :updated_by, :integer, default: 1
  end
end
