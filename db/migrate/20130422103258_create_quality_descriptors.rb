class CreateQualityDescriptors < ActiveRecord::Migration
  def change
    create_table :quality_descriptors do |t|
      t.integer :personal_quality_id
      t.string :grade
      t.string :descriptor
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
   
    add_index :quality_descriptors, [:personal_quality_id, :grade]
  end
end
