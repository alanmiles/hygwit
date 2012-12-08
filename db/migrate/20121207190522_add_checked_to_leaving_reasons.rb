class AddCheckedToLeavingReasons < ActiveRecord::Migration
  def change
    add_column :leaving_reasons, :checked, :boolean, default: false
    add_column :leaving_reasons, :updated_by, :integer, default: 1
  end
end
