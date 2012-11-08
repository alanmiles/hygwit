class CreateLeavingReasons < ActiveRecord::Migration
  def change
    create_table :leaving_reasons do |t|
      t.string :reason
      t.boolean :terminated, default: false

      t.timestamps
    end
  end
end
