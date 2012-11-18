class CreateJobfamilies < ActiveRecord::Migration
  def change
    create_table :jobfamilies do |t|
      t.string :job_family
      t.boolean :approved, default: false
      t.integer :created_by, default: 1

      t.timestamps
    end
  end
end
