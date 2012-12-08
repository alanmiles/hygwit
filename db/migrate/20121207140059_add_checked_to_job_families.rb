class AddCheckedToJobFamilies < ActiveRecord::Migration
  def change
    add_column :jobfamilies, :checked, :boolean, default: false
    add_column :jobfamilies, :updated_by, :integer, default: 1
  end
end
