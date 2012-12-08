class AddCheckedToDescriptors < ActiveRecord::Migration
  def change
    add_column :descriptors, :checked, :boolean, default: false
  end
end
