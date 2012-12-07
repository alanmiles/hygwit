class AddCheckedToCurrencies < ActiveRecord::Migration
  def change
    add_column :currencies, :checked, :boolean, default: false
    add_column :currencies, :updated_by, :integer, default: 1
  end
end
