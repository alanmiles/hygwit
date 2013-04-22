class CreateContractCats < ActiveRecord::Migration
  def change
    create_table :contract_cats do |t|
      t.integer :business_id
      t.string :contract
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    add_index :contract_cats, [:business_id, :contract]
  end
end
