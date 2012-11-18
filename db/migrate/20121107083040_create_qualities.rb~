class CreateQualities < ActiveRecord::Migration
  def change
    create_table :qualities do |t|
      t.string :quality
      t.boolean :approved, default: false
      t.integer :created_by

      t.timestamps
    end
  end
end
