class CreatePayCategories < ActiveRecord::Migration
  def change
    create_table :pay_categories do |t|
      t.string :category
      t.string :description
      t.boolean :on_payslip, default: false
      t.integer :created_by, default: 1
      t.boolean :checked, default: false
      t.integer :updated_by

      t.timestamps
    end
  end
end
