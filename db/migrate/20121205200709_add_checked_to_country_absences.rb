class AddCheckedToCountryAbsences < ActiveRecord::Migration
  def change
    add_column :country_absences, :checked, :boolean, default: false
    add_column :country_absences, :updated_by, :integer, default: 1
  end
end
