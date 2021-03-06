class CreateDescriptors < ActiveRecord::Migration
  def change
    create_table :descriptors do |t|
      t.integer :quality_id
      t.string :grade
      t.string :descriptor
      t.boolean :reviewed, default: false
      t.integer :updated_by, default: 1

      t.timestamps
    end
  end
end
