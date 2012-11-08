class CreateGrievanceTypes < ActiveRecord::Migration
  def change
    create_table :grievance_types do |t|
      t.string :grievance

      t.timestamps
    end
  end
end
