class CreateInsuranceRates < ActiveRecord::Migration
  def change
    create_table :insurance_rates do |t|
      t.integer :country_id
      t.integer :insurance_code_id
      t.boolean :source_employee, default: true
      t.integer :threshold_id
      t.integer :ceiling_id
      t.decimal :contribution
      t.boolean :percent, default: true
      t.boolean :rebate, default: false
      t.integer :created_by, default: 1
      t.integer :updated_by, default: 1
      t.boolean :checked, default: false
      t.date		:effective
      t.date    :cancellation

      t.timestamps
    end
  end
end
