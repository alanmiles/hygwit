class CreateGrievanceCats < ActiveRecord::Migration
  def change
    create_table :grievance_cats do |t|
      t.integer :business_id
      t.string :grievance
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    add_index :grievance_cats, [:business_id, :grievance]
  end
end
