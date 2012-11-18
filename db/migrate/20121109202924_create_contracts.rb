class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.string :contract
      t.integer :created_by, default: 1

      t.timestamps
    end
  end
end
