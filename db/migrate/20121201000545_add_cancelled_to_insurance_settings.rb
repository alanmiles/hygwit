class AddCancelledToInsuranceSettings < ActiveRecord::Migration
  def change
    add_column :insurance_settings, :cancellation_date, :date
  end
end
