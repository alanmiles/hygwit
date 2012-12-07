class AddCheckedToNationalities < ActiveRecord::Migration
  def change
    add_column :nationalities, :checked, :boolean, default: false
    add_column :nationalities, :updated_by, :integer, default: 1
  end
end
