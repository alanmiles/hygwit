class CreateAdvanceTypes < ActiveRecord::Migration
  def change
    create_table :advance_types do |t|
      t.string :name
      t.integer :created_by, default: 1
      t.boolean :checked, default: false
      t.integer :updated_by

      t.timestamps
    end
  end
end
