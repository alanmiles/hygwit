class AddCheckedToHolidays < ActiveRecord::Migration
  def change
    add_column :holidays, :checked, :boolean, default: false
    add_column :holidays, :updated_by, :integer, default: 1
  end
end
