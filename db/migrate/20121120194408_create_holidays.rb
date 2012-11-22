class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.integer :country_id
      t.string :name
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
