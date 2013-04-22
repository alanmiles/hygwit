class CreateDisciplinaryCats < ActiveRecord::Migration
  def change
    create_table :disciplinary_cats do |t|
      t.integer :business_id
      t.string :category
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    add_index :disciplinary_cats, [:business_id, :category]
  end
end
