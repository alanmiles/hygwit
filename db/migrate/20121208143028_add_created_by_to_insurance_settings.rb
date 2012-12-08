class AddCreatedByToInsuranceSettings < ActiveRecord::Migration
  def change
    add_column :insurance_settings, :created_by, :integer, default: 1
  end
end
