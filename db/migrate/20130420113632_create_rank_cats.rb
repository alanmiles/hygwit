class CreateRankCats < ActiveRecord::Migration
  def change
    create_table :rank_cats do |t|
      t.integer :business_id
      t.string :rank
      t.integer :position
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    add_index :rank_cats, [:business_id, :rank]
  end
end
