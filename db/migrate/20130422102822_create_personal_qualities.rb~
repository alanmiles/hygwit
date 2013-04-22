class CreatePersonalQualities < ActiveRecord::Migration
  def change
    create_table :personal_qualities do |t|
      t.integer :business_id
      t.string :quality
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    add_index :personal_qualities, [:business_id, :quality]
  end
end
