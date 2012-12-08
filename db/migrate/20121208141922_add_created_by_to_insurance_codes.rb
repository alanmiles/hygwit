class AddCreatedByToInsuranceCodes < ActiveRecord::Migration
  def change
    add_column :insurance_codes, :created_by, :integer, default: 1
  end
end
