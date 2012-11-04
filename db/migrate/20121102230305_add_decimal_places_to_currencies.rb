class AddDecimalPlacesToCurrencies < ActiveRecord::Migration
  def change
    add_column :currencies, :decimal_places, :integer, default: 2
  end
end
