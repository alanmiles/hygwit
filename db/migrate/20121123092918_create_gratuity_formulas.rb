class CreateGratuityFormulas < ActiveRecord::Migration
  def change
    create_table :gratuity_formulas do |t|
      t.integer :country_id
      t.integer :service_years_from
      t.integer :service_years_to
      t.decimal :termination_percentage, precision: 5, scale: 2
      t.decimal :resignation_percentage, precision: 5, scale: 2

      t.timestamps
    end
  end
end
