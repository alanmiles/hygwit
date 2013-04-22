class CreatePayrollItems < ActiveRecord::Migration
  def change
    create_table :payroll_items do |t|
      t.integer :business_id
      t.string :item
      t.integer :payroll_cat_id
      t.string :short_name
      t.boolean :deduction, default: false
      t.boolean :gross_salary, default: false
      t.boolean :fixed, default: false
      t.integer :position
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    add_index :payroll_items, [:business_id, :payroll_cat_id, :item]
  end
end
