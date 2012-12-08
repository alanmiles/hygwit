class AddCreatedByToGratuityFormulas < ActiveRecord::Migration
  def change
    add_column :gratuity_formulas, :created_by, :integer, default: 1
  end
end
