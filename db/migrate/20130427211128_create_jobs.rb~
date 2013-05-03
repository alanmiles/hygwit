class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :department_id
      t.string :job_title
      t.integer :jobfamily_id
      t.integer :positions, default: 1
      t.boolean :current, default: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    add_index :jobs, [:department_id, :job_title], unique: true
    add_index :jobs, :jobfamily_id
  end
end
