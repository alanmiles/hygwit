class CreateCountryAdmins < ActiveRecord::Migration
  def change
    create_table :country_admins do |t|
      t.integer :user_id
      t.integer :country_id

      t.timestamps
    end
  end
end
