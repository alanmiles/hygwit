class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.integer :business_id
      t.string :department
      t.string :dept_code
      t.integer :division_id
      t.boolean :current, default: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    add_index :departments, [:business_id, :department]
    add_index :departments, [:division_id, :department] 
  end
end
