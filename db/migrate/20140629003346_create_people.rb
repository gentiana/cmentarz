class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :grave_id
      t.string :first_name
      t.string :last_name
      t.string :family_name
      t.text :description
      t.integer :lived
      t.string :raw_record
      t.integer :data_state, default: 1
      t.text :notes

      t.timestamps
    end
    add_index :people, :grave_id
  end
end
