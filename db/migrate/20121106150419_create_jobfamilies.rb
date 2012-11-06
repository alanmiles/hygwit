class CreateJobfamilies < ActiveRecord::Migration
  def change
    create_table :jobfamilies do |t|
      t.string :job_family
      t.boolean :approved, default: false
      t.integer :created_by

      t.timestamps
    end
  end
end
