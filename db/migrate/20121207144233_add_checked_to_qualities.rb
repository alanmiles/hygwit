class AddCheckedToQualities < ActiveRecord::Migration
  def change
    add_column :qualities, :checked, :boolean, default: false
    add_column :qualities, :updated_by, :integer, default: 1
  end
end
