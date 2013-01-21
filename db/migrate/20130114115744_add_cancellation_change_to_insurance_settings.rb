class AddCancellationChangeToInsuranceSettings < ActiveRecord::Migration
  def change
    add_column :insurance_settings, :cancellation_change, :boolean, default: false
  end
end
