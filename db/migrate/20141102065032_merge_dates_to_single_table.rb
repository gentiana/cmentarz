class MergeDatesToSingleTable < ActiveRecord::Migration
  def change
    create_table :custom_dates do |t|
      t.integer :birth_day_id
      t.integer :death_day_id
      t.integer :year
      t.integer :month
      t.integer :day

      t.timestamps
    end
    # add_index :death_dates, :person_id
  end
end
