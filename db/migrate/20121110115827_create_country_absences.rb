class CreateCountryAbsences < ActiveRecord::Migration
  def change
    create_table :country_absences do |t|
      t.integer :country_id
      t.string :absence_code
      t.integer :paid, default: 100
      t.boolean :sickness, default: false
      t.integer :maximum_days_year
      t.boolean :documentation_required, default: true
      t.string :notes

      t.timestamps
    end
  end
end
