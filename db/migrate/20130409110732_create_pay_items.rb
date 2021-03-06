class CreatePayItems < ActiveRecord::Migration
  def change
    create_table :pay_items do |t|
      t.string :item
      t.integer :pay_category_id
      t.string :short_name
      t.boolean :deduction, default: false
      t.boolean :taxable, default: false
      t.boolean :fixed, default: false
      t.integer :position
      t.integer :created_by, default: 1
      t.boolean :checked, default: false
      t.integer :updated_by

      t.timestamps
    end
  end
end
