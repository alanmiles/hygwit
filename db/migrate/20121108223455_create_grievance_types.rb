class CreateGrievanceTypes < ActiveRecord::Migration
  def change
    create_table :grievance_types do |t|
      t.string :grievance
      t.integer :created_by, default: 1

      t.timestamps
    end
  end
end
