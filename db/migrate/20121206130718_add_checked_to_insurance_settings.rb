class AddCheckedToInsuranceSettings < ActiveRecord::Migration
  def change
    add_column :insurance_settings, :checked, :boolean, default: false
    add_column :insurance_settings, :updated_by, :integer, default: 1
  end
end
