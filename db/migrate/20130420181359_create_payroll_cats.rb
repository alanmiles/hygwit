class CreatePayrollCats < ActiveRecord::Migration
  def change
    create_table :payroll_cats do |t|
      t.integer :business_id
      t.string :category
      t.string :description
      t.boolean :on_payslip, default: false
      t.integer :position
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    add_index :payroll_cats, [:business_id, :category]
  end
end
