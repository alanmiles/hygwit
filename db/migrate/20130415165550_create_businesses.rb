class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.integer :country_id
      t.string :address_1
      t.string :address_2
      t.string :city
      t.integer :sector_id
      t.integer :created_by
      t.integer :updated_by
      t.string :registration_number
      t.string :bank, default: "(Name of your payroll bank)"
      t.string :bank_branch, default: "(Branch identifier)"
      t.string :iban, default: "(Business iban code)"
      t.boolean :calendar_days, default: true
      t.decimal :hours_per_day, precision:4, scale:2, default: 8.0
      t.decimal :hours_per_month, precision:5, scale:2, default: 160.00
      t.integer :weekend_day_1, default: 6
      t.integer :weekend_day_2, default: 7
      t.decimal :standard_ot_rate, precision:3, scale:2, default: 1.25
      t.decimal :supplementary_ot_rate, precision:3, scale:2, default: 1.5
      t.decimal :double_ot_rate, precision:3, scale:2, default: 2.0
      t.string :standard_start_time, default: '08:00'
      t.boolean :autocalc_benefits, default: false
      t.boolean :pension_scheme, default: false
      t.boolean :bonus_provision, default: false
      t.integer :close_date, default: 15
      t.date :last_payroll_date
      t.string :home_airport
      t.integer :review_interval, default: 6
      t.boolean :setup_complete, default: false

      t.timestamps
    end
  end
end
