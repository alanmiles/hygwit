class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.string :sector
      t.integer :created_by, default: 1
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end
