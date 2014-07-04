class AddShortNameToQuarter < ActiveRecord::Migration
  def change
    add_column :quarters, :short_name, :string
  end
end
