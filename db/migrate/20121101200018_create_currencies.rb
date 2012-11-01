class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :currency
      t.string :code

      t.timestamps
    end
    add_index :currencies, :code
  end
end
