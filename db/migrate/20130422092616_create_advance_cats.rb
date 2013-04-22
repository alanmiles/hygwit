class CreateAdvanceCats < ActiveRecord::Migration
  def change
    create_table :advance_cats do |t|
      t.integer :business_id
      t.string :name
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    add_index :advance_cats, [:business_id, :name]
  end
end
