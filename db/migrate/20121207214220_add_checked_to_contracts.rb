class AddCheckedToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :checked, :boolean, default: false
    add_column :contracts, :updated_by, :integer, default: 1
  end
end
