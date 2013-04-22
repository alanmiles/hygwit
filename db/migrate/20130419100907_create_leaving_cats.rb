class CreateLeavingCats < ActiveRecord::Migration
  def change
    create_table :leaving_cats do |t|
      t.integer :business_id
      t.string :reason
      t.boolean :full_benefits, default: false
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    add_index :leaving_cats, [:business_id, :reason]
  end
end
