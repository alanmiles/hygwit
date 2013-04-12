class CreateLoanTypes < ActiveRecord::Migration
  def change
    create_table :loan_types do |t|
      t.string :name
      t.integer :qualifying_months, default: 12
      t.integer :max_repayment_months, default: 12
      t.integer :max_salary_multiplier, default: 12
      t.integer :max_amount, default: 1000
      t.decimal :apr, precision: 4, scale: 2, default: 0
      t.integer :created_by, default: 1
      t.boolean :checked, default: false
      t.integer :updated_by

      t.timestamps
    end
  end
end
