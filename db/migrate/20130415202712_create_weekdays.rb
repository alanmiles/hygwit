class CreateWeekdays < ActiveRecord::Migration
  def change
    create_table :weekdays do |t|
      t.string :day
      t.string :abbreviation

      t.timestamps
    end
  end
end
