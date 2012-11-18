class CreateDisciplinaryCategories < ActiveRecord::Migration
  def change
    create_table :disciplinary_categories do |t|
      t.string :category
      t.integer :created_by, default: 1

      t.timestamps
    end
  end
end
