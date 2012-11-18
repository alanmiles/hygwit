class CreateNationalities < ActiveRecord::Migration
  def change
    create_table :nationalities do |t|
      t.string :nationality
      t.integer :created_by, default: 1

      t.timestamps
    end
    add_index :nationalities, :nationality
  end
end
