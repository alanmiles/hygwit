class AddCurrentToAbsenceCats < ActiveRecord::Migration
  def change
    add_column :absence_cats, :current, :boolean, default: true
  end
end
