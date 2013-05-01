class AddAccessRightsToBusinessAdmins < ActiveRecord::Migration
  def change
    add_column :business_admins, :manager, :boolean, default: false
    add_column :business_admins, :staff, :boolean, default: false
    add_column :business_admins, :payroll, :boolean, default: false
    add_column :business_admins, :attendance, :boolean, default: false
    add_column :business_admins, :recruitment, :boolean, default: false
    add_column :business_admins, :performance, :boolean, default: false
    add_column :business_admins, :training, :boolean, default: false
    add_column :business_admins, :property, :boolean, default: false
    add_column :business_admins, :pro, :boolean, default: false
  end
end
