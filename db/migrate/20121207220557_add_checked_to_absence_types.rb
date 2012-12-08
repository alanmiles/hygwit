class AddCheckedToAbsenceTypes < ActiveRecord::Migration
  def change
    add_column :absence_types, :checked, :boolean, default: false
    add_column :absence_types, :updated_by, :integer, default: 1
  end
end
