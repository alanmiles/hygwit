class CreateInsuranceCodes < ActiveRecord::Migration
  def change
    create_table :insurance_codes do |t|
      t.integer :country_id
      t.string :insurance_code
      t.string :explanation
      t.boolean :checked, default: false
      t.integer :updated_by, default: 1
      t.date :cancelled

      t.timestamps
    end
  end
end
