class AddPositionToPayCategories < ActiveRecord::Migration
  def change
    add_column :pay_categories, :position, :integer
  end
end
