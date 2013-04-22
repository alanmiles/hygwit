class CreateLeaverActivities < ActiveRecord::Migration
  def change
    create_table :leaver_activities do |t|
      t.integer :business_id
      t.string :action
      t.integer :position
      t.integer :contract, default: 2
      t.integer :residence, default: 2
      t.integer :nationality, default: 2
      t.integer :marital_status, default: 2
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    add_index :leaver_activities, [:business_id, :action]
  end
end
