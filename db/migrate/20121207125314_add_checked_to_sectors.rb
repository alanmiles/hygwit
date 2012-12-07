class AddCheckedToSectors < ActiveRecord::Migration
  def change
    add_column :sectors, :checked, :boolean, default: false
    add_column :sectors, :updated_by, :integer, default: 1
  end
end
