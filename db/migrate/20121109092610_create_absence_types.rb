class CreateAbsenceTypes < ActiveRecord::Migration
  def change
    create_table :absence_types do |t|
      t.string :absence_code
      t.integer :paid, default: 100
      t.boolean :sickness, default: false
      t.integer :maximum_days_year
      t.boolean :documentation_required, default: true
      t.string :notes
      t.integer :created_by, default: 1

      t.timestamps
    end
  end
end
