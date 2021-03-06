class AddQuotasToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :ethnicity_reports, :boolean, default: false
    add_column :countries, :ethnicity_details, :text
    add_column :countries, :reserved_jobs, :boolean, default: false
    add_column :countries, :disability_rules, :boolean, default: false
    add_column :countries, :disability_details, :text
  end
end
