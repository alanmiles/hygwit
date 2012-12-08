class AddCheckedToGrievanceTypes < ActiveRecord::Migration
  def change
    add_column :grievance_types, :checked, :boolean, default: false
    add_column :grievance_types, :updated_by, :integer, default: 1
  end
end
