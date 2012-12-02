class CreateInsuranceSettings < ActiveRecord::Migration
  def change
    create_table :insurance_settings do |t|
      t.integer :country_id
      t.string :shortcode
      t.string :name
      t.decimal :weekly_milestone
      t.decimal :monthly_milestone
      t.decimal :annual_milestone
      t.date :effective_date

      t.timestamps
    end
  end
end
