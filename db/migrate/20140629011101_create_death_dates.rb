class CreateDeathDates < ActiveRecord::Migration
  def change
    create_table :death_dates do |t|
      t.integer :person_id
      t.integer :year
      t.integer :month
      t.integer :day

      t.timestamps
    end
    add_index :death_dates, :person_id
  end
end
