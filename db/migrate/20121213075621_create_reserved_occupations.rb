class CreateReservedOccupations < ActiveRecord::Migration
  def change
    create_table :reserved_occupations do |t|
      t.integer :country_id
      t.integer :jobfamily_id
      t.boolean :checked, default: false
      t.integer :created_by, default: 1
      t.integer :updated_by, default: 1

      t.timestamps
    end
  end
endnnot
