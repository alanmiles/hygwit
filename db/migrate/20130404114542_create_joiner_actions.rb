class CreateJoinerActions < ActiveRecord::Migration
  def change
    create_table :joiner_actions do |t|
      t.string :action
      t.integer :contract, default: 2
      t.integer :residence, default: 2
      t.integer :nationality, default: 2
      t.integer :marital_status, default: 2
      t.integer :position
      t.integer :created_by, default: 1
      t.boolean :checked, default: false
      t.integer :updated_by

      t.timestamps
    end
  end
end
