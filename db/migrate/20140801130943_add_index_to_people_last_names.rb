class AddIndexToPeopleLastNames < ActiveRecord::Migration
  def change
    add_index :people, :last_name
  end
end
