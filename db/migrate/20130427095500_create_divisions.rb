class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.integer :business_id
      t.string :division
      t.boolean :current, default: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    add_index :divisions, [:business_id, :division]
  end
end
