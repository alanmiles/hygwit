class CreateBusinessAdmins < ActiveRecord::Migration
  def change
    create_table :business_admins do |t|
      t.integer :business_id
      t.integer :user_id
      t.integer :created_by
      t.boolean :main_contact, default: false

      t.timestamps
    end
    
    add_index :business_admins, :business_id
    add_index :business_admins, :user_id
  end
end
