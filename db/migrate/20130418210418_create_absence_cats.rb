class CreateAbsenceCats < ActiveRecord::Migration
  def change
    create_table :absence_cats do |t|
      t.integer :business_id
      t.string :absence_code
      t.integer :paid, default: 100
      t.boolean :sickness, default: false
      t.integer :maximum_days_year
      t.boolean :documentation_required, default: true
      t.string :notes
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    add_index :absence_cats, [:business_id, :absence_code, :sickness]
    
  end
end
