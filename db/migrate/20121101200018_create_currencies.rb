class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :currency
      t.string :code
      t.integer :created_by, default: 1

      t.timestamps
    end
    add_index :currencies, :code
  end
end
