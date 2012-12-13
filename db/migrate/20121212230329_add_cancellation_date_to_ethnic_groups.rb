class AddCancellationDateToEthnicGroups < ActiveRecord::Migration
  def change
    add_column :ethnic_groups, :cancellation_date, :date
  end
end
