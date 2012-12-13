class CreateEthnicGroups < ActiveRecord::Migration
  def change
    create_table :ethnic_groups do |t|
      t.integer :country_id
      t.string :ethnic_group
      t.boolean :checked, default: false
      t.integer :created_by, default: 1
      t.integer :updated_by, default: 1

      t.timestamps
    end
  end
end
