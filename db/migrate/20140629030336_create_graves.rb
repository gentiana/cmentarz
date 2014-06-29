class CreateGraves < ActiveRecord::Migration
  def change
    create_table :graves do |t|
      t.integer :quarter_id
      t.integer :type
      t.integer :row
      t.string :number
      t.text :description
      t.string :family_name
      t.integer :data_state, default: 1
      t.text :notes

      t.timestamps
    end
  end
end
