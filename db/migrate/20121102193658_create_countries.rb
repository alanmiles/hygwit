class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :country
      t.integer :nationality_id
      t.integer :currency_id
      t.boolean :taxation, default: false
      t.boolean :insurance, default: true
      t.integer :probation_days, default: 90
      t.integer :max_hours_day, default: 9
      t.integer :max_hours_week, default: 45
      t.integer :max_hours_day_ramadan
      t.integer :max_hours_week_ramadan
      t.boolean :sickness_accruals, default: false
      t.integer :retirement_age_m, default: 60
      t.integer :retirement_age_f, default: 55
      t.decimal :OT_rate_standard, precision: 3, scale: 2
      t.decimal :OT_rate_special, precision: 3, scale: 2
      t.time :nightwork_start
      t.time :nightwork_end
      t.integer :max_loan_ded_salary, default: 15
      t.text :notes
      t.boolean :complete, default: false
      t.integer :created_by, default: 1

      t.timestamps
    end
  end
end
