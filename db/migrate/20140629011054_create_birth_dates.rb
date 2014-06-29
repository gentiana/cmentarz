class CreateBirthDates < ActiveRecord::Migration
  def change
    create_table :birth_dates do |t|
      t.integer :person_id
      t.integer :year
      t.integer :month
      t.integer :day

      t.timestamps
    end
    add_index :birth_dates, :person_id
  end
end
