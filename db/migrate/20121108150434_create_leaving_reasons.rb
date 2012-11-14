class CreateLeavingReasons < ActiveRecord::Migration
  def change
    create_table :leaving_reasons do |t|
      t.string :reason
      t.boolean :full_benefits, default: false

      t.timestamps
    end
  end
end
